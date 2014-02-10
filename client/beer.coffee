Meteor.startup(->
  Deps.autorun(->
    Meteor.subscribe("players")
    Meteor.subscribe("games")
    Meteor.subscribe("results")
  )
)

@player = ->
  Session.get('player_id')

@game = ->
  Games.findOne({player_id: player()})

@gameExists = ->
  game()?

@result = ->
  Results.findOne({player_id: player()}, {sort: [['round', 'desc']]})

Template.join.show = ->
  !gameExists()

Template.join.events({
  'click button': ->
    playerId = Players.insert({})
    Session.set('player_id', playerId)
})

Template.game.show = ->
  gameExists()

Template.game.events({
  'click button': ->
    order = parseInt($('.order').val())
    Results.update result()._id, {$set: {placedOrder: order}}
})

Template.result.data = ->
  Results.find({player_id: player()})

Template.gameStatus.data = ->
  result()
