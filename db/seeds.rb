# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Profile.create([{ name: 'PMU' }, { name: 'LOTO BONHEUR' }, { name: 'Nouveaux inscrits' }, { name: 'Participants en cours' }, { name: 'Participants non actifs' }, { name: 'Numéro unique' }, { name: 'Liste de numéros' }])

Period.create([{ name: 'Jour', number_of_days: 1 }, { name: 'Semaine', number_of_days: 7 }, { name: 'Mois', number_of_days: 30 }])
