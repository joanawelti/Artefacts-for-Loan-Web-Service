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


#Factory.define :administrator do |administrator|
#  administrator.firstname              "Joana" 
#  administrator.lastname               "Welti"
#  administrator.administrator          true  
#  administrator.email                  "joana.welti.10@aberdeen.ac.uk"
#  administrator.address                "Hillhead Halls of Residence"
#  administrator.city                   "Old Aberdeen"
#  administrator.postcode               "AB24 1WU"
#  administrator.country                "United Kingdom"
#  administrator.mobile                 "07756734344"
#  administrator.password               "passwordForJoana"
#  administrator.password_confirmation  "passwordForJoana"
#end