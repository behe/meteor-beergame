Template.gameNew.events({
  'click button': ->
    $('.join').hide()
    playerId = Players.insert({})
    Session.set('playerId', playerId)

    handle = Games.find().observe({
      added: (game) =>
        console.log 'playerId', playerId
        if game.player_id == playerId
          console.log 'game.player_id', game.player_id
          Meteor.Router.to('gameShow', game)
          handle.stop()
    })
})
