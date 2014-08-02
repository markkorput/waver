class @Wave extends Backbone.Model
  defaults:
    amount: 10

  initialize: ->
    # make sure we have a class-wide path object
    if !(path = @get('path'))
      path = new paper.Path()
      @set(path: path)

    # build path segments/points
    # point #1 (fixed)
    path.moveTo start = new paper.Point(0, paper.view.viewSize.height * 0.5)
    segmentWidth = paper.view.viewSize.width / (@get('amount') + 1)
    # segment dividing points
    _.each _.range(@get('amount')), (i) =>
      path.lineTo start.add([segmentWidth * i, 0])
    # last point (fixed)
    path.lineTo(start.add([paper.view.viewSize.width, 0]))

    # define look
    path.strokeColor = 'white'
    path.smooth()


class @WaveOps extends Backbone.Model
  initialize: ->
    # if we didn't get a target, we'll just create our own
    @set(target: new Wave()) if !@get 'target'

    paper.view.on 'frame', @_dripFrame



  drip: (x, force) ->
    path = @get('target').get('path')

    _.each path.segments, (segment, idx) =>
      point = segment.point
      dist = Math.abs(point.x - x)
      point.ty ||= point.y
      point.ty += Math.sin(dist) * force

  _dripFrame: (e) =>
    # e = {delta: <float time since last frame>, time: <float in seconds>, count: <frame>}
    path = @get('target').get('path')

    ty = paper.view.viewSize.height * 0.5

    _.each path.segments, (segment, idx) =>
      point = segment.point
      point.ty = ty + ((point.ty || point.y) - ty)*0.95
      point.y += (point.ty - point.y) * 0.1


