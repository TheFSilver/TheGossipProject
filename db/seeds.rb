# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

# Creation de 10 villes
10.times do
  city = City.create(name: Faker::Address.city, postal_code: Faker::Address.zip_code)
end

# Creation de 10 tags
10.times do
  tag = Tag.create(title: Faker::Job.field)
end

recipient_number = 1
# On crée une boucle pour "peupler" chaque ville
City.all.each do |city|
  
  # Creation de 10 utilisateurs
  10.times do
    user = User.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.safe_email, age: Faker::Number.between(18, 60), description: Faker::Lorem.sentences(2), city_id: city.id)
  end

  # Creation de 20 potins
  20.times do
    gossip = nil
    randomuser = User.all.where(city_id: city.id).sample
      gossip = Gossip.create(title: Faker::Book.title, content: Faker::Lorem.sentences(2), date: Faker::Date.forward(7), user_id: randomuser.id)
      
      # Mise à jour des tag_id de tout les gossips
      gossip.tags << Tag.all.sample
      
      # Mise à jour des gossip_id de tout les tags
      Tag.all.each do |tag|
        tag.gossips << gossip
      end
  end

  # Creation de 1 private message avec un nombre aléatoire de destinataires compris entre 1 et 3 maximum
  recipient_number = Faker::Number.between(1, 3)
  
  if recipient_number == 1
    privatemessage = PrivateMessage.create(content: Faker::GameOfThrones.quote, date: Faker::Date.forward(7), sender_id: User.all.sample.id, receiver_id: User.all.sample.id, receiver2_id: nil, receiver3_id: nil)
    
  elsif recipient_number == 2
    privatemessage = PrivateMessage.create(content: Faker::GameOfThrones.quote, date: Faker::Date.forward(7), sender_id: User.all.sample.id, receiver_id: User.all.sample.id, receiver2_id: User.all.sample.id, receiver3_id: nil)
    
  elsif recipient_number == 3
    privatemessage = PrivateMessage.create(content: Faker::GameOfThrones.quote, date: Faker::Date.forward(7), sender_id: User.all.sample.id, receiver_id: User.all.sample.id, receiver2_id: User.all.sample.id, receiver3_id: User.all.sample.id)
  end

  # Creation de 20 commentaires générés aléatoirement
  20.times do
    random_gossip = Gossip.all.sample
    comment = random_gossip.comments.create(content: Faker::Lorem.sentences(1), gossip_id: random_gossip.id, user_id: User.all.sample.id)
  end

  # Creation de 20 sous-commentaires générés aléatoirement
  20.times do
    random_comment = Comment.all.sample
    subcomment = random_comment.comments.create(content: Faker::Lorem.sentences(1), gossip_id: random_comment.gossip_id, user_id: User.all.sample.id)
  end

  # Creation de 20 likes générés aléatoirement
  20.times do
    random_user = User.all.sample
    x = Faker::Number.between(1, 2)
    if x == 1
      like = Like.create(user_id: random_user.id, gossip_id: Gossip.all.sample.id)
    elsif x == 2
      like = Like.create(user_id: random_user.id, comment_id: Comment.all.sample.id)
    end
  end
end
