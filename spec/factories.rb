Factory.define :user do |user|
user.name  'user2'
user.email 'user2@test.com'
user.password 'foobar'
user.password_confirmation 'foobar'
end


Factory.sequence :email do |n|
"person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
micropost.content  "Lorem ipsum"
micropost.association :user
end

