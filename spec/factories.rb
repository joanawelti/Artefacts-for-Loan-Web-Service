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