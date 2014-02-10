@Players = new Meteor.Collection('players')
@Games = new Meteor.Collection('games')
@Rounds = new Meteor.Collection('rounds')
@Results = new Meteor.Collection('results')

Players.allow({
  insert: ->
    true
})

Results.allow({
  update: ->
    true
})
