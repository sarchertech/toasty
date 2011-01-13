def account_seed
  n = %w{suncity toast sunworld mauitan supertan fantastictan ultratan
         crazygirls magictan psychotan}

  n.each do |name|
    Factory.create(:account, :name => name)
  end
end

def salon_seed
  n = %w{douglas dallashwy lithia}

  (1..10).each do |i|
    n.each do |name|
      Factory.create(:salon, :account_id => i, :identifier => name)
    end
  end
end

def bed_seed
  (1..30).each do |i|
    (1..(rand(11) + 5) ).each do |n|
      Factory.create(:bed, :salon_id => i, :bed_number => n)
    end 
  end   
end

def customer_seed
  f = %w{Seth George Frank Jim Jill Jack Terry Aspen Bill Kimberly Ivan Xorg 
       Terrell Jackson Ava Arden Michael Rhonda Juli Josh Jerome Sally
       Jessica Kim Jen jennifer Octavius Axe Sam Club Seven Cola Ignacius
       Olivander Voldemort Edmond Anita Daniel Janette Merriwether Tosh
       Dontravius Latrine Nati Suki Amy Emily Audrey Lucy Fred}
       
  l = %w{Smith Johnson Williams Jones Brown Davis Miller Wilson Moore taylor 
       anderson thomas jackson white Harris Martin Thompson Garcia Martinez
       Robinson Clark Rodriguez Lewis Lee Walker Hall Allen Young Hernandez
       King wright Lopez Hill Scott Green Adams Baker Gonzalez Nelson Carter
       mitchell Perez Roberts Turner Phillips Campbell parker eVans Edwards
       Collins}

  c = %w{Douglasville Lithia Marietta Ballground Austell Mableton Adairsville
       Macon Valdosta WarnerRobins Duluth Augusta}

  r = %w{770 404 680 606 812 807 912 808 402 406}
  p = %w{949 489 706 555 687 428 219 907 603 857}
  n = %w{1622 8233 6587 4525 6214 8468 5632 4652 4628 3526}
  
  # function(a[n]) = b[n] = 3 * a -2
  # a = 1, 2, 3 - b = 1, 4, 7
  # if a is account_number and there are 3 salons per account
  # take a then add b to rand(3)_you will get a saslon_id 
  # that matches account where account.id = a 
  def by_three(a)
    3 * a - 2
  end
  
  time = Time.now

  (1..10000).each do
    a = rand(10) + 1
    s = rand(3) + by_three(a)
    t = time + rand(180).days
    
    Factory.create(:customer, :first_name => f[rand(50)],
      :last_name => l[rand(50)],
      :city => c[rand(12)],
      :account_id => a,
      :salon_id => s,
      :phone_number => r[rand(10)]+p[rand(10)]+n[rand(10)],
      :level => rand(5) + 1,
      :customer_type => rand(4) + 1,
      :paid_through => t) 
  end
end

def user_seed
  def by_three(a)
    3 * a -2
  end

  (1..10).each do |a|
    (0..2).each do |s|
      s = by_three(a) + s
      Factory.create(:user, :first_name => "michael", :last_name => "krontz",
                     :account_id => a, :salon_id => s)
      Factory.create(:user, :first_name => "seth", :last_name => "brown",
                     :account_id => a, :salon_id => s)
      Factory.create(:user, :first_name => "sandra", :last_name => "floyd",
                     :account_id => a, :salon_id => s)
      Factory.create(:user, :first_name => "zane", :last_name => "brown",
                     :account_id => a, :salon_id => s)
    end
  end  
end

def tan_session_seed
  time = Time.now

  (1..10000).each do |i|
    t = time - rand(500).days
    
    Factory.create(:tan_session, :customer_id => i, 
                   :created_at => t)
  end
end

account_seed
salon_seed
bed_seed
customer_seed
user_seed
tan_session_seed
