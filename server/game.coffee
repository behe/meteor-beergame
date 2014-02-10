Meteor.publish('players', ->
  Players.find()
)

Meteor.publish('games', ->
  Games.find()
)

Meteor.publish('results', ->
  Results.find()
)

Meteor.startup(->
  query  = Players.find()
  handle = query.observe({
    added: (player) ->
      unless Games.findOne({player_id: player._id})?
        game = startNewGame(player)
        advanceRound(game)
  })
  Results.find().observeChanges({
    changed: (id, fields) ->
      if fields.placedOrder?
        result = Results.findOne(id)
        Games.update {player_id: result.player_id}, {$set: {production_request: fields.placedOrder}, $inc: {round: 1}}
        game = Games.findOne({player_id: result.player_id})
        advanceRound(game)
  })
)

startNewGame = (player) ->
  gameId = Games.insert({
    player_id: player._id,
    round: 1,
    balance: 12,
    customer_demand: [4,4,4,4],
    production_request: 4,
    production_delay: [4,4]
  })
  Games.findOne(gameId)

advanceRound = (game) ->
  incomingBalance = game.balance
  incomingSupply = game.production_delay.shift()
  incomingOrder = game.customer_demand.shift() || 8
  inventory = Math.max(0,incomingBalance) + incomingSupply
  backlog = Math.abs(Math.min(0,incomingBalance)) + incomingOrder
  deliveredOrder = Math.min(inventory, backlog)
  inventory = inventory - deliveredOrder
  backlog = backlog - deliveredOrder
  game.balance = inventory - backlog
  game.production_delay.push game.production_request
  game.production_request = undefined
  Results.insert({
    player_id: game.player_id,
    round: game.round,
    incomingBalance: incomingBalance,
    incomingSupply: incomingSupply,
    incomingOrder: incomingOrder,
    deliveredOrder: deliveredOrder,
    currentInventory: inventory,
    currentBacklog: backlog,
    currentBalance: game.balance
  })
  Games.update(game._id, game)
