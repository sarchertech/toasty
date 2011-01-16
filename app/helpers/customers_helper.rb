module CustomersHelper
  def type_and_details_for(customer)
    str = ", #{customer.details}" if customer.details
    "#{customer.word_for_type}#{str}"
  end
end
