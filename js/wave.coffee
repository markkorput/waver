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
      path.lineTo start.add([
        segmentWidth * i, Math.sin(Math.PI * 0.5 * i) * 20
      ])
    # last point (fixed)
    path.lineTo(start.add([paper.view.viewSize.width, 0]))

    # define look
    path.strokeColor = 'white'
    path.smooth()


class @WaveOps extends Backbone.Model
  initialize: ->
    # if we didn't get a target, we'll just create our own
    @set(target: new Wave()) if !@get 'target'

