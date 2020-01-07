class TransactionsController < ApplicationController
  #prepend_before_filter :authenticate_user!
  require 'rubygems'
  require 'write_xlsx'

  layout "administrator"

  def list
    @transactions_active = "active"
    @transactions = SmsTransaction.all.order("created_at DESC")
    @transactions_count = @transactions.count
    @transactions = @transactions.page(params[:page])
  end

  def numbers_list
    transaction_id = params[:transaction_id]
    numbers = MessageLog.where("sms_transaction_id = ?", transaction_id).select("msisdn")
    export("liste-de-numeros-soumis", numbers)
  end

  def sent_numbers_list
    transaction_id = params[:transaction_id]
    numbers = MessageLog.where("sms_transaction_id = ? AND (status = '1701' OR status = 'PENDING')", transaction_id).select("msisdn")
    export("liste-de-numeros-transmis", numbers)
  end

  def failed_numbers_list
    transaction_id = params[:transaction_id]
    numbers = MessageLog.where("sms_transaction_id = ? AND status <> '1701' AND status <> 'PENDING'", transaction_id).select("msisdn")
    export("liste-de-numeros-non-transmis", numbers)
  end

  def export(title, numbers)
    File.delete("#{Rails.root}/public/#{title}.xlsx") if File.exist?("#{Rails.root}/public/#{title}.xlsx")
    workbook = WriteXLSX.new("#{Rails.root}/public/#{title}.xlsx")
    worksheet = workbook.add_worksheet
    i = 1
    numbers.each do |number|
      worksheet.write("A#{i}", number.msisdn)
      i+=1
    end
    workbook.close

    send_file(
      "#{Rails.root}/public/#{title}.xlsx",
      filename: "#{title}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end
end
