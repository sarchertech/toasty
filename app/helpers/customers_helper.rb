module CustomersHelper
  def customer_details(customer)
    case customer.customer_type
    when 2
      "paid through #{customer.paid_through.strftime('%b %d') }"
    when 3
      "#{customer.sessions_left} sessions left"
    end
  end
end
