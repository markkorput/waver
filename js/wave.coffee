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

  drip: (pos, force) ->
    path = @get('target').get('path') 
    # location = path.getNearestLocation(point)
    # segment = location.segment
    segment = _.sample(path.segments)

    # abort if fixed
    return if segment.fixed

    point = segment.point
    point.y += force

    if segment.previous && !segment.previous.point.fixed
      segment.previous.point.y += force * -0.8

    if segment.next && !segment.next.point.fixed
      segment.next.point.y += force * -0.8

  _dripFrame: (e) =>
    # e = {delta: <float time since last frame>, time: <float in seconds>, count: <frame>}

    dynamics =
      mass: 80
      friction: 0.9
      strength: 0.1
      restLength: 100

    dynamics.invMass = 1/dynamics.mass
    dynamics.mamb = dynamics.invMass * dynamics.invMass

    path = @get('target').get('path')

    _.each path.segments, (segment, idx) =>
      return if segment.fixed

      point = segment.point

      # previous position influence
      force = 1 - dynamics.friction * 0.0001

      ty = paper.view.viewSize.height * 0.5
      dy = (point.y - (point.py || point.y)) * force
      point.py = point.y
      #dy = (ty - point.y) * 0.03
      point.y = Math.max(point.y + dy, 0)


      return if !segment.previous 

      # every point is influenced by its prevPoint
      delta = point.y - segment.previous.point.y
      deltaX = point.x - segment.previous.point.x
      return if delta == 0

      dist = Math.abs(Math.sqrt(delta*delta + deltaX*deltaX))
      normDistStrength = (dist - dynamics.restLength) / (dist * dynamics.mamb) * dynamics.strength
      delta = delta * normDistStrength * dynamics.invMass * 0.2


      point.y += delta
      segment.previous.point.y -= delta

    path.smooth()


