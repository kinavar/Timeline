s = Snap('.svg').attr({viewBox: '0 0 500 100'})
canvasWidth = 500
height = 2
dayStart = 8
dayFinish = 20
dayTime = dayFinish-dayStart

getToday = ()->
  date = new Date()
  date.setHours(8)
  date.setMinutes(0)


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
      t.append(ts.clone().attr(getUseParams(arr[i],arr[i+1])))
      arr.splice(0,1)
      return
  setAnimation: ()->
    t=@timeLine
    t.select('.line').animate {width: canvasWidth}, 1000, ->
      t.select('.text').animate({opacity:1}, 500)
      t.selectAll('.inUse').animate {opacity:1}, 500
  init: () ->
    @addLine()
    @addRoomName()
    @addUses()
    @timeLine.transform('t0,'+offset.get())
    @setAnimation()







room = new TimeLine({roomName: 'Red Room',times:[now,now1,now2,now3]})
room2 = new TimeLine({roomName: 'Blue Room',times:[now,now1,now2,now3]})
room3 = new TimeLine({roomName: 'Grey Room',times:[now,now1,now2,now3]})
room4 = new TimeLine({roomName: 'Grey hjk Room',times:[]})


