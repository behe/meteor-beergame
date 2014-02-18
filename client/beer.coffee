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
  console.log 'game', game()
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

Template.result.rendered = ->
  myChart = $("#myChart").get(0)
  console.log 'created', myChart
  if myChart?
    ctx = myChart.getContext("2d")
    @chart = new Chart(ctx)
  console.log 'rendered', @chart
  if @chart?
    results = Results.find({player_id: player()}).fetch()
    data = {
      labels: (result.round for result in results),
      datasets: [
        {
          fillColor : "rgba(0,0,0,0)",
          strokeColor : "rgba(0,0,0,1)",
          pointColor : "rgba(0,0,0,1)",
#          pointStrokeColor : "#fff",
          data: (0 for result in results)
        }
        {
          fillColor : "rgba(151,187,205,0.5)",
          strokeColor : "rgba(151,187,205,1)",
          pointColor : "rgba(151,187,205,1)",
          pointStrokeColor : "#fff",
          data: (result.currentBalance for result in results)
        }
      ]
    }
    console.log 'data', data
    @chart.Line(data, {bezierCurve: false, animationSteps: 20})

Template.gameStatus.data = ->
  result()
