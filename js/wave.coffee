class @Wave extends Backbone.Model
  defaults:
    amount: 0

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

    # # to close the shape off...
    # segment1 = path.add(new paper.Point(paper.view.viewSize.width + 10, paper.view.viewSize.height * 0.5))
    # segment1.fixed = true
    # segment2 = path.add(new paper.Point(paper.view.viewSize.width + 10, paper.view.viewSize.height + 10))
    # segment2.fixed = true
    # segment3 = path.add(new paper.Point(-10, paper.view.viewSize.height + 10))
    # segment3.fixed = true
    # segment4 = path.add(new paper.Point(-10, paper.view.viewSize.height * 0.5))
    # segment4.fixed = true
    # path.closePath(true)

    # define look
    clr = new paper.Color(Math.random(), Math.random(), Math.random())
    path.strokeColor = clr
    # path.fillColor = clr
    path.smooth()

  pointByX: (x) ->
    @_existingPointByX(x) || @_createPointByX(x)

  _existingPointByX: (x) ->
    _.find _.map(@get('path').segments, (segment) -> segment.point), (point) -> point.x == x

  _createPointByX: (x) ->
    path = @get 'path'
    # go over all existing points
    p = _.find _.map(path.segments, (segment) -> segment.point), (point, idx) ->
      # if we find one (the first), that has an x coordinate bigger than our coordinate
      # insert our new point before it
      return null if point.x < x
      segment = path.insert(idx, new paper.Point(x, 0))
      return segment.point

    return p if p

    # getting here, means we didn't find any existing point with a bigger x-coordinate than our new point;
    # simply add it to the end of the path then
    segment = path.add(new paper.Point(x, 0))
    return segment.point

  setPoints: (points_coordinates) ->
    path = @get('path')
    path.removeSegments()
    _.each points_coordinates, (coords) =>
      @pointByX(coords[0]).y = coords[1]
    path.smooth()


class @WaveOps extends Backbone.Model
  initialize: ->
    # if we didn't get a target, we'll just create our own
    @set(target: new Wave()) if !@get 'target'
    paper.view.on 'frame', @_frame

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

  _frame: (event) =>
    return if (@pathHeight || 0) == 0
    @pathHeight = @pathHeight * 0.95
    @pathHeight = 0 if @pathHeight < 0.5

    _.each @get('target').get('path').segments, (segment, i) =>
      return if segment.fixed
      sinSeed = event.count*10 + (i + i % 30) * 100
      sinHeight = Math.sin(sinSeed / 200) * @pathHeight
      segment.point.y = Math.sin(sinSeed / 100) * sinHeight + paper.view.viewSize.height/2


class @WaveSiner extends Backbone.Model
  defaults:
    root: 0
    waveLength: 80
    amplitude: 10
    flatline: 0
    seed: 0

  initialize: ->
    # if we didn't get a target, we'll just create our own
    @set(target: new Wave(amount: 0)) if !@get 'target'
    paper.view.on 'frame', @_frame
    @set(flatline: paper.view.viewSize.height*0.5)
    @set(seed: Math.random()*1000.0)

  _frame: (event) =>
    @set
      amplitude: Math.sin(event.count * 0.05 + @get('seed')) * 100
      waveLength: 80 + Math.sin(event.count * 0.001 + @get('seed')) * 30
      root: -30 + Math.sin(event.count * 0.03 + @get('seed')) * 30

    root = @get('root')
    length = @get('waveLength')
    flat = @get('flatline')
    amp = @get('amplitude')

    @get('target').setPoints _.map _.range(root, paper.view.size.width + length*0.25, length*0.25), (x) =>
      return [x, Math.sin(x - root / length * (Math.PI * 2)) * amp + flat]
