# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
f = %w{Seth George Frank Jim Jill Jack Terry Aspen Bill Kimberly Ivan Xorg 
       Terrell Jackson Ava Arden Michael Rhonda Juli Josh Jerome Sally
       Jessica Kim Jen jennifer Octavius Axe Sam Club Seven Cola Ignacius
       Olivander Voldemort Edmond Anita Daniel Janette Merriwether Tosh
       Dontravius Latrine Nati Suki Amy Emily Audrey Lucy George}
       
l = %w{Smith Johnson Williams Jones Brown Davis Miller Wilson Moore taylor 
       anderson thomas jackson white Harris Martin Thompson Garcia Martinez
       Robinson Clark Rodruguez Lewis Lee Walker Hall Allen Young Hernandez
       King wright Lopez Hill Scott Green Adams Baker Gonzalez Nelson Carter
       mitchell Perez Roberts Turner Phillips Campbell parker eVans Edwards
       Collins}

c = %w{Douglasville Lithia Marietta Ballground Austell Mableton Adairsville
       Macon Valdosta WarnerRobins Duluth Augusta}

a = %w{770 404 680 606 812 807 912 808 402 406}
p = %w{949 489 706 555 687 428 219 907 603 857}
n = %w{1622 8233 6587 4525 6214 8468 5632 4652 4628 3526}

(1..10000).each do
  Factory.create(:customer, :first_name => f[rand(50)],
                            :last_name => l[rand(50)],
                            :city => c[rand(12)],
                            :account_id => rand(5),
                            :salon_id => rand(10),
                            :phone_number => a[rand(10)]+p[rand(10)]+n[rand(10)] ) 
end

