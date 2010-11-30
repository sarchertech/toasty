class User < ActiveRecord::Base
  belongs_to :account
  belongs_to :salon
end
