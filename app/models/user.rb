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
#  salt               :string(255)
#  admin              :boolean          default(FALSE)
#

class User < ActiveRecord::Base
	has_many :microposts, :dependent => :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :following_users, :through => :relationships, :source =>  :followed
	has_many :reverse_relationships, foreign_key: "followed_id", dependent: :destroy, :class_name =>  "Relationship"
	has_many :followed_by_users, :through => :reverse_relationships, :source =>  :follower

	attr_accessor :password

	email_regex = /\A[\w._-]+@([\da-z]*\.)+[\da-z]+\z/i

	validates :name, :presence => true,
	:length => {:maximum => 50}

	validates :email, :presence => true,
	:format => {:with => email_regex},
	:uniqueness => {:case_sensitive => false}

	validates :password, :presence => true,
	:confirmation => true,
	:length => {:within => 6..40}

	validates_confirmation_of :password

	before_save :encrypt_password

	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end

	def User.authenticate(email, submitted_password)
		user =  User.find_by_email(email)
		# puts "User for the email #{email} : #{user}"
		(user && user.has_password?(submitted_password)) ? user : nil
		# return nil if user.nil?
		# return user if user.has_password?(submitted_password)
	end


	def User.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end

	def encrypt_password
		self.salt =  make_salt if new_record?
		self.encrypted_password = encrypt(self.password)
	end

	def encrypt(string)
		secure_hash("#{salt}--#{string}")
	end

	def make_salt
		secure_hash("#{Time.now.utc}--#{password}")
	end

	def secure_hash(string)
		Digest::SHA2.hexdigest(string)
	end

	def feed
		Micropost.where("user_id = ?", id)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(followed)
		relationships.find_by_followed_id(followed.id).destroy if following?(followed)
	end

	def following?(followed)
		self.relationships.find_by_followed_id(followed.id)
	end
end
