class CustomerTransactionsController < ApplicationController
  layout "customer"

  def list
    @transactions_active = "active"
    @transactions = Customer.find_by_id(session[:customer]).sms_transactions.order("created_at DESC")
    @transactions_count = @transactions.count
    @transactions = @transactions.page(params[:page])
  end
end
