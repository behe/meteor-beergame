Meteor.startup(->
  Deps.autorun(->
    Meteor.subscribe("players")
    Meteor.subscribe("games")
    Meteor.subscribe("results")
  )
)

@player = ->
  Session.get('playerId') || @game()?.player_id || null

@game = ->
  Games.findOne(Session.get('gameId'))

@gameExists = ->
  console.log 'game', game()
  game()?

@result = ->
  Results.findOne({player_id: player()}, {sort: [['round', 'desc']]})
