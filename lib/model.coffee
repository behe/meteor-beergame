@Players = new Meteor.Collection('players')
@Games = new Meteor.Collection('games')
@Results = new Meteor.Collection('results')

Players.allow({
  insert: ->
    true
})

Results.allow({
  update: ->
    true
})
