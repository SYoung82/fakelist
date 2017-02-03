# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Section.create(name: "Services")
Section.create(name: "Electronics")
Section.create(name: "Personals")
Section.create(name: "Sporting Goods")
Section.create(name: "Other")

User.create(username: "Scott", email: "scott@email.com", password: "password")
User.create(username: "Sean", email: "sean@email.com", password: "password")
User.create(username: "Layne", email: "layne@email.com", password: "password")
User.create(username: "Kristen", email: "kristen@email.com", password: "password")
User.create(username: "Bozo", email: "bozo@email.com", password: "password")

Ad.create(title: "Electronic Devices", content: "Electronic devices of all sorts for sale, no Apple...", user_id: 1, section_id: 2)
Ad.create(title: "Junk", content: "Stuff for sale, mostly junk, let's be honest, but ...", user_id: 1, section_id: 5)
Ad.create(title: "Clown Shoes", content: "Size 27, like new, only highway miles!", user_id: 5, section_id: 5)
Ad.create(title: "Legal Advice", content: "Contact me for legal advice.", user_id: 3, section_id: 1)
Ad.create(title: "Vehicle Service ", content: "Any make, any model, competitive prices", user_id: 2, section_id: 1)
Ad.create(title: "Man Seeking Woman", content: "Hit me up boo", user_id: 5, section_id: 3)
Ad.create(title: "Ab Blaster Pro", content: "Someone take this pos off my hands", user_id: 4, section_id: 4)
