Factory.define :customer do |f|
  f.last_name "Krontz" 
  f.first_name "Rhonda"
  f.sequence(:customer_number) {|n| (1000+n).to_s}
  f.level 1
  f.email "rhonda@toasty.com"
  f.phone_number "7709491622"
  f.address "4430 Dallas Hwy"
  f.city "Douglasville"
  f.zip_code "30134"
  f.state "GA"
  f.account_id 1
  f.salon_id 1
  f.customer_type 1
end

Factory.define :user do |f|
  f.last_name "Krontz"
  f.first_name "Michael"
  f.security_level 1
  f.account_id 1
  f.password "secret"
  f.password_confirmation "secret"
end

Factory.define :account do |f|
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
  f.sequence(:identifier) {|n| "douglas#{n}" }
end

Factory.define :bed do |f|
  f.salon_id 1 
  f.bed_number 1
  f.level 1
  f.name "Sundash 5000"
  f.max_time 15
end

Factory.define :tan_session do |f|
  f.bed_id 1
  f.customer_id 1
  f.salon_id 1
  f.minutes 5
end
