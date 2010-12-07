Factory.define :customer do |f|
  f.last_name "Krontz" 
  f.first_name "Rhonda"
  f.customer_number "1234"
  f.level 1
  f.email "rhonda@toasty.com"
  f.phone_number "7709491622"
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
  f.account_id 1
  f.zip_code "30134"
  f.time_zone "Eastern Time (US & Canada)"
  f.address "4430 Hwy 5"
  f.city "Douglasville"
  f.state "GA"
  f.identifier "douglasville"
end

Factory.define :bed do |f|
  
end

Factory.define :tan_session do |f|
  
end
