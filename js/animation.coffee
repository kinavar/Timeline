
canvasWidth = 500
canvasHeight = 0
height = 2
dayStart = 8
dayFinish = 20
dayTime = dayFinish-dayStart

s = Snap('.svg').attr({viewBox: "0 0 #{canvasWidth+20} #{canvasHeight}"})


getToday = ()->
  date = new Date()
  date.setHours(8)
  date.setMinutes(0)

alternateDate = (hours) ->
  if hours > 12
    return hours-12+':00pm'
  if hours is 12
    return hours+':00pm'
  else
    return hours+':00am'



drawBigPoints = () ->
  period = canvasWidth/dayTime
  startPoint = 10
  for i in [0..dayTime]
    h=hour.clone().appendTo(s)
    h.transform('t'+startPoint)
    m=minutes.clone().appendTo(s)
    m.transform('t'+((period/2)+startPoint))
    h.select('.hourText').node.innerHTML = alternateDate((dayStart+i))
    addHover(h)
    startPoint+=period







bigPoint = s.circle(0,5,1).attr({fill: '#999'}).addClass 'point'
hourText = s.text(-4,3,'').attr({fontSize: '4px', fill: '#999', 'font-weight': '100'}).addClass 'hourText'
markLine = s.line(0,5,0,canvasHeight).attr({stroke: '#999','stroke-width': .5, 'stroke-dasharray': '2,2', opacity: .15}).addClass 'markLine'
hour = s.g(bigPoint,hourText,markLine)

smallPoint = s.circle(0,5,.5).attr({fill: '#999'}).addClass 'point'
smallMarkLine = s.line(0,5,0,canvasHeight).attr({stroke: '#999','stroke-width': .5, 'stroke-dasharray': '1,1', opacity: .15}).addClass 'markLine'
minutes = s.g(smallPoint,smallMarkLine)


addHover = (e) ->
  e.mouseover ()->
    @.select('.point').animate {r:1.5}, 200
    @.select('.markLine').animate {'stroke-dasharray': '100%', opacity: .8}, 200
  e.mouseout () ->
    @.select('.point').animate {r:1}, 200
    @.select('.markLine').animate {'stroke-dasharray': '2,2', opacity: .15}, 200
hour.toDefs()
minutes.toDefs()




lineText = s.text(1,15, 'Room1').attr({fontSize: '8px', fill: '#26A69A', 'font-weight': 'bold', opacity: 0}).addClass('text')
line = s.rect(0,20,0,height).attr({fill: '#80CBC4'}).addClass('line')
timeLine = s.g(lineText,line)
timeLine.toDefs()


ts = s.rect(200,20,0,height).attr({fill: '#26A69A', opacity:0}).addClass 'inUse'
ts.toDefs()


hoursToMs = (h) ->
  h*3600000

now = new Date().getTime()
now1 = now+hoursToMs(.5)
now2 = now+hoursToMs(2)
now3 = now+hoursToMs(2.5)

getUseParams = (t1,t2) ->
  startTime = (t1-getToday())
  startLength = (startTime/hoursToMs(dayTime))*100
  useTime = (t2-t1)/(hoursToMs(dayTime))*100
  startPoint = canvasWidth/100*startLength
  useWidth = canvasWidth/100*useTime
  return {
    x :startPoint,
    width : useWidth
  }


offset =
  height: 0,
  get: ()->
    @height++*20



class TimeLine
  constructor: (params) ->
    @roomName = params.roomName
    @times = params.times
    @init()

  addLine: () ->
    @timeLine = timeLine.clone().appendTo(s)
  addRoomName: () ->
    @timeLine.select('.text').node.innerHTML = @roomName
  addUses: ()->
    t=@timeLine
    @times.forEach (e,i,arr) ->
      t.append(ts.clone().attr(getUseParams(e.startTime,e.finishTime)))
      return
  setAnimation: ()->
    t=@timeLine
    t.select('.line').animate {width: canvasWidth}, 1000, ->
      t.select('.text').animate({opacity:1}, 500)
      t.selectAll('.inUse').animate {opacity:1}, 500
  canvasAdjust: () ->
    canvasHeight = canvasHeight+20
    s.attr({viewBox: "0 0 #{canvasWidth+20} #{canvasHeight+10}"})
    s.selectAll('.markLine').attr({y2:canvasHeight})
  init: () ->
    @canvasAdjust()
    @addLine()
    @addRoomName()
    @addUses()
    @timeLine.transform('t10,'+offset.get())
    @setAnimation()



drawBigPoints()

new TimeLine({roomName: 'Red Room',times:[{startTime:now,finishTime:now1},{startTime:now2,finishTime:now3}]})
new TimeLine({roomName: 'Blue Room',times:[{startTime:now,finishTime:now1},{startTime:now2,finishTime:now3}]})
new TimeLine({roomName: 'Grey Room',times:[{startTime:now,finishTime:now1}]})
#room4 = new TimeLine({roomName: 'Grey hjk Room',times:[]})
#room5 = new TimeLine({roomName: 'Grey hjk Room',times:[]})


