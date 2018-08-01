# The Gossip Project
> Revisité par François D.

## Consignes de l'exercice

Je vous invite à (re)consulter les consignes sur le site de <a href="https://www.thehackingproject.org/week/4/day/4">The Hacking Project</a>.

Pour toutes questions, commentaires, suggestions et dons (espèces, CB, chèques, virements bancaires et crypto-monnaies acceptées), contactez-moi sur le slack en cherchant : **_@Francois D._**

## Résolution de l'exercice

Le but ici, étant pour vous, de voir une des nombreuses manières de résoudre le problème donné et d'analyser/décortiquer chaque ligne de code afin de comprendre 
Pour recréer vous-même l'exercice, suivez simplement le guide en recopiant les commandes ci-dessous, une à une, dans votre terminal pour obtenir l'architecture ci-dessous :

<img src="https://preview.ibb.co/i6ppET/Screen_Shot_2018_07_29_at_21_23_59.png" alt="Screen_Shot_2018_07_29_at_21_23_59" border="0" title="Aspect visuel de la base de donnée">

* Commençons par créer le dossier de l'exercice sur votre bureau :
``` 
cd Desktop/
mkdir TheGossipProject
rails new TheGossipProject/
cd TheGossipProject/
```
* Rajoutons la gem **"<a href="https://github.com/stympy/faker">Faker</a>"** dans le fichier **_`Gemfile`_** pour générer des données automatiquement : 
```
open Gemfile
```
* Ajoutons la ligne suivante à la fin du fichier puis enregistrons-le avant de le fermer :
```
gem 'faker'
```
* Retournons dans le terminal et mettons à jour notre systême avec les gems nécessaires :
```
bundle install
```
Nous avons terminé la configuration du dossier, à présent, nous allons nous pencher sur l'exercice à proprement parler...

* Toujours dans le terminal, nous allons configurer la base de donnée
```
rails g model City name:string postal_code:integer
rails g model User first_name:string last_name:string email:string age:integer description:text city:references
rails g model Gossip title:string content:text date:timestamp user:references
rails g model Tag title:string
rails g migration CreateJoinTableGossipTag gossip tag
rails g model PrivateMessage content:text date:timestamp sender_id:integer receiver_id:integer receiver2_id:integer receiver3_id:integer
rails g model Comment content:text user:references gossip:references commentable_id:integer commentable_type:string
rails g model Like user:references gossip:references comment:references
```
* Modifions le model **"City"** situé dans `app/models/city.rb` pour qu'il soit semblable à ceci:
```
class City < ApplicationRecord
  has_many :users
end
```
* Modifions le model **"User"** situé dans `app/models/user.rb` pour qu'il soit semblable à ceci:
```
class User < ApplicationRecord
  belongs_to :city
  has_many :sent_messages, :class_name => "Message", :foreign_key => "sender_id"
  has_many :received_messages, :class_name => "Message", :foreign_key => "receiver_id"
  has_many :received_messages, :class_name => "Message", :foreign_key => "receiver2_id"
  has_many :received_messages, :class_name => "Message", :foreign_key => "receiver3_id"
  has_many :gossips
  has_many :comments
end
```
* Modifions le model **"Gossip"** situé dans `app/models/gossip.rb` pour qu'il soit semblable à ceci:
```
class Gossip < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :comments, as: :commentable
  has_many :likes
end
```
* Modifions le model **"Tag"** situé dans `app/models/tag.rb` pour qu'il soit semblable à ceci:
```
class Tag < ApplicationRecord
  has_and_belongs_to_many :gossips, optional: true
end
```
* Modifions le model **"PrivateMessage"** situé dans `app/models/privatemessage.rb` pour qu'il soit semblable à ceci:
```
class PrivateMessage < ApplicationRecord
  belongs_to :sender, :class_name=>'User', :foreign_key=>'sender_id'
  belongs_to :receiver, :class_name=>'User', :foreign_key=>'receiver_id'
  belongs_to :receiver2, :class_name=>'User', :foreign_key=>'receiver2_id', optional: true
  belongs_to :receiver3, :class_name=>'User', :foreign_key=>'receiver3_id', optional: true
end
```
* Modifions le model **"Comment"** situé dans `app/models/comment.rb` pour qu'il soit semblable à ceci:
```
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :gossip
  belongs_to :commentable, polymorphic: true 
  has_many :comments, as: :commentable
  has_many :likes
end
```
* Modifions le model **"Like"** situé dans `app/models/like.rb` pour qu'il soit semblable à ceci:
```
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :gossip, optional: true
  belongs_to :comment, optional: true
end
```
* Éditons maintenant le fichier **"Seeds"** situé dans `db/seeds.rb` pour qu'il contienne ceci :
```
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
```
Au cas ou vous ne l'auriez pas remarqué, ce fichier **"Seeds"** est quelque peu particulier.

Au lieu de nous contenter d'avoir une petite base de données contenant uniquement :
* 10 villes / 10 utilisateurs / 20 potins / 10 tags / 1 message privé / 20 commentaires / 20 sous-commentaires / 20 likes

J'ai décidé qu'il serait plus intéressant d'avoir une base de données contenant pour chacune des 10 villes :
* 10 utilisateurs / 20 potins / 10 tags / 1 message privé / 20 commentaires / 20 sous-commentaires / 20 likes

On se retrouvera donc avec au total :
* 10 villes / 100 utilisateurs / 200 potins / 100 tags / 10 messages privés / 200 commentaires / 200 sous-commentaires / 200 likes

Évidemment, vous être libre de modifier ces "quantités" à votre guise plus tard...

* Validons les modifications faites dans la configuration de notre base de données :
```
rails db:migrate
rails db:seed
```
La base de données étant 10 fois plus lourde que prévu, ayez un peu de patience pendant que votre machine fait le travail...

## Vérification de l'exercice

Une fois de plus, je vous invite à (re)consulter le site de <a href="https://www.thehackingproject.org/week/4/day/4">The Hacking Project</a> pour vérifier que la base de donnée obtenue est correcte.

Si vous utilisez une application telle que <a href="http://sqlitebrowser.org/">DB Browser</a> ou <a href="http://sqlitestudio.pl/?act=download">SQLStudio</a>, vous trouverez la base de donnée dans `db/development.sqlite3`

Enjoy & Keep Coding !
