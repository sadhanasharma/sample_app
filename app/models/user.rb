# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#

class User < ActiveRecord::Base
 attr_accessor :password
	
	email_regex =  /\A[\w._-]+@([\da-z]*\.)+[\da-z]+\z/i

	validates  :name ,  :presence => true,
	:length => { :maximum => 50}

	validates  :email , :presence => true,
	:format => {:with => email_regex},
	:uniqueness => {:case_sensitive => false}

	validates :password , :presence => true,
				:confirmation => true,
				:length => { :within => 6..40 }

	validates_confirmation_of :password

end
