class @Wave extends Backbone.Model
  defaults:
    amount: 10

  initialize: ->
    # make sure we have a class-wide path object
    if !(path = @get('path'))
      path = new paper.Path()
      @set(path: path)

    if @get('amount') < 2
      dx = paper.view.viewSize.width
    else
      dx = paper.view.viewSize.width / (@get('amount') - 1)

    y = paper.view.viewSize.height * 0.5

    _.each _.range(@get('amount')), (i) =>
      segment = path.add(new paper.Point(dx * i, y))
      if i == 0 || i == @get('amount') - 1
        segment.fixed = true
        segment.linear = true

    segment1 = path.add(new paper.Point(paper.view.viewSize.width + 10, paper.view.viewSize.height * 0.5))
    segment1.fixed = true
    segment2 = path.add(new paper.Point(paper.view.viewSize.width + 10, paper.view.viewSize.height + 10))
    segment2.fixed = true
    segment3 = path.add(new paper.Point(-10, paper.view.viewSize.height + 10))
    segment3.fixed = true
    segment4 = path.add(new paper.Point(-10, paper.view.viewSize.height * 0.5))
    segment4.fixed = true

    # define look
    path.closePath(true)
    clr = new paper.Color(Math.random(), Math.random(), Math.random())
    path.strokeColor = clr
    path.fillColor = clr

    path.smooth()

    segment1.linear = true
    segment2.linear = true
    segment3.linear = true
    segment4.linear = true

class @WaveOps extends Backbone.Model
  initialize: ->
    # if we didn't get a target, we'll just create our own
    @set(target: new Wave()) if !@get 'target'
    paper.view.on 'frame', @_dripFrame

  drip: (pos) ->
    # @dripPos = pos
    # @pathHeight = pos.y
    
    that = this
    t = new TWEEN.Tween(pathHeight: @pathHeight) 
      .to({pathHeight: pos.y}, 250)
      .easing( TWEEN.Easing.Exponential.Out )
      .onUpdate (a,b,c) ->
        that.pathHeight = @pathHeight
      .start()

  _dripFrame: (event) =>
    @pathHeight ||= 0
    # @pathHeight += (paper.view.center.y - (@dripPos || paper.view.center).y - @pathHeight) / 10
    @pathHeight = @pathHeight * 0.99
    @pathHeight = 0 if @pathHeight < 0.5

    _.each @get('target').get('path').segments, (segment, i) =>
      return if segment.fixed
      sinSeed = event.count + (i + i % 10) * 100
      sinHeight = Math.sin(sinSeed / 200) * @pathHeight
      yPos = Math.sin(sinSeed / 100) * sinHeight + paper.view.viewSize.height/2
      segment.point.y = yPos
