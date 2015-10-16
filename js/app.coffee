angular.module('app', [])

  .directive 'timeBar', ()->
    {
      restrict: 'E'
      templateUrl:  'template/timeline.html'
      controller: 'timeLineController'

    }

  .controller 'timeLineController', (TimeBar) ->
    times = TimeBar.data
    buildTimeLine(times)


  .service 'TimeBar', () ->
    {
      data : [
#        {roomName: 'Red Room',times:[{startTime:1444966027360,finishTime:1444967827360}]},
#        {roomName: 'Blue Room',times:[{startTime:1444966027360,finishTime:1444967827360}]}
      ]
    }

