Meteor.Router.add({
  '/': 'gameNew',
  '/game/:_id': {
    to: 'gameShow',
    and: (id) ->
      Session.set('gameId', id)
  }
})
