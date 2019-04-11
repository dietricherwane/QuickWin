class CustomerMessageLogsController < ApplicationController
  layout "customer"

  def list
    @transactions_active = "active"
    @transaction = SmsTransaction.find_by_id(params[:transaction_id])
    if @transaction.blank?
      render file: "#{Rails.root}/public/404.html", status: 404, layout: false
    else
      @message_logs = @transaction.message_logs
      @message_logs_count = @message_logs.count
      @message_logs = @message_logs.page(params[:page])
    end
  end

  def export
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.name = 'export'
    @transaction = SmsTransaction.find_by_id(params[:transaction_id])
    if @transaction.blank?
      render file: "#{Rails.root}/public/404.html", status: 404, layout: false
    else
      @message_logs = @transaction.message_logs
      i = 1
      @message_logs.each do |message_log|
        r = sheet1.row(i)
        r.push message_log.msisdn, message_log.message
        i += 1
      end

      path = Rails.root.to_s + '/public/export.xls'
      book.write path

      send_file(path, filename: "export.xls")
    end
  end
end
