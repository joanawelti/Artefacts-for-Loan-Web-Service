# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.firstname              "John" 
  user.lastname               "Doe"
  user.administrator          false
  user.email                  "john@example.com"
  user.address                "Examplestreet 20"
  user.city                   "Aberdeen"
  user.postcode               "AB24 1WU"
  user.country                "United Kingdom"
  user.mobile                 "07756734344"
  user.password               "examplepassword"
  user.password_confirmation  "examplepassword"
  user.long                   12.574833
  user.lat                    25.234513
end

Factory.sequence :email do |n|
  "person#{n}@example.com"
end


Factory.define :artefact do |artefact|
  artefact.name "Name"
  artefact.description "Description for artefact"
  artefact.visible true
  artefact.association :user
  artefact.photo File.join(Rails.root, 'spec', 'images', 'test.jpg')
end

Factory.define :comment do |comment|
  comment.content "Foo bar"
  comment.association :user 
  comment.association :artefact
end

Factory.define :loan do |loan| 
  now = Date.today
  loan.association :user
  loan.association :artefact
  loan.loan_start now
  loan.loan_end now + 1.month
end