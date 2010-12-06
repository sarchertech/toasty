Factory.define :customer do |f|
  
end

Factory.define :user do |f|
  
end

Factory.define :account do |f|
  f.customer_location_access false
  f.user_location_access false
  f.account_number 123
  f.name 'Sun City'  
end

Factory.define :salon do |f|
  
end

Factory.define :bed do |f|
  
end

Factory.define :tan_session do |f|
  
end
