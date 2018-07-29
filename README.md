# The Gossip Project
> Revisité par François D.

## Consignes de l'exercice

Je vous invite à (re)consulter les consignes sur le site de <a href="https://www.thehackingproject.org/week/4/day/4">The Hacking Project</a>.

Pour toute question, contactez-moi sur le slack en cherchant : **_@Francois D._**

## Résolution de l'exercice

Pour recréer vous-même l'exercice, suivez simplement le guide en recopiant les commandes ci-dessous, une à une, dans votre terminal:

* Commençons par créer le dossier de l'exercice sur votre bureau :
``` 
cd Desktop/
mkdir TheGossipProject
rails new TheGossipProject/
cd TheGossipProject/
```
* Rajoutons la gem "Faker" dans le fichier Gemfile pour générer des données automatiquement : 
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
