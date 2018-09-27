require_relative 'base'

class User < Base
  attr_accessor :email, :password, :first_name, :partner_name, :engage_date,
                :wedding_date, :venue, :location, :guests, :budget

  def self.default
    where(email: Howitzer.app_test_user).first
  end
end
