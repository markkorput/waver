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

    # define look
    path.strokeColor = 'white'
    path.smooth()


class @WaveOps extends Backbone.Model
  initialize: ->
    # if we didn't get a target, we'll just create our own
    @set(target: new Wave()) if !@get 'target'
    paper.view.on 'frame', @_dripFrame

  drip: (pos) ->
    @dripPos = pos

  _dripFrame: (event) =>
    @pathHeight ||= 0
    @pathHeight += (paper.view.center.y - (@dripPos || paper.view.center).y - @pathHeight) / 10

    _.each @get('target').get('path').segments, (segment, i) =>
      sinSeed = event.count + (i + i % 10) * 100
      sinHeight = Math.sin(sinSeed / 200) * @pathHeight
      yPos = Math.sin(sinSeed / 100) * sinHeight + paper.view.viewSize.height/2
      segment.point.y = yPos
