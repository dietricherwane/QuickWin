class TransactionsController < ApplicationController
  layout "administrator"

  def list
    @transactions_active = "active"
    @transactions = SmsTransaction.all.order("created_at DESC")
    @transactions_count = @transactions.count
    @transactions = @transactions.page(params[:page])
  end
end
