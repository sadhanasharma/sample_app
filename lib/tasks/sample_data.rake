require "faker"

namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		make_users
		make_microposts
		make_relationship
	end
end

def make_microposts
	User.all(:limit => 6).each do |user|
		50.times do
			user.microposts.create!(:content => Faker::Lorem.sentence(5))
		end
	end
end

def make_users
	admin =	User.create!(:name => "Example User",
		:email => "example@railstutorial.org",
		:password => "foobar",
		:password_confirmation => "foobar")

	admin.toggle!(:admin)
	99.times do |n|
		name = Faker::Name.name
		email = "example-#{n+1}@railstutorial.org"
		password = "password"
		password_confirmation = "password"

		User.create!(:name => name, :email => email,
			:password => password, :password_confirmation => password)
	end
end

def make_relationship
	users = User.all
	user  = users.first
	followed_users = users[2..50]
	followers      = users[3..40]
	followed_users.each { |followed| user.follow!(followed) }
	followers.each      { |follower| follower.follow!(user) }
end