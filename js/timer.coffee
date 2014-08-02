class @Timer extends Backbone.Model
  initialize: ->
    @on 'change:state', @_onStateChange, this
    @on 'end', (-> @trigger 'loop reset' if @_looping()), this
    @on 'end', (-> @set(progress: 1, time: @get('duration')).stop() if !@_looping()), this
    @on 'reset', (-> @set(startTime: @get('startTime') + @get('duration'))), this

    @stop()

  start: -> @set state: 'playing'
  stop: -> @set state: 'stopped'
  setPaused: (pause) -> 
    if pause
      @set state: 'paused'
    else
      @set state: 'playing'

  curTime: -> new Date().getTime()

  _time: -> @curTime() - @get('startTime') if @get('startTime')

  _progress: ->
    if (t = @_time()) && d = @get('duration')
      return t * 1.0 / d

  setProgress: (prog) ->
    # TODO; this isn't a very elegant solution, find something better
    @set(startTime: @curTime() - prog * @get('duration'))

  _looping: -> @get('loop') != false

  update: ->
    if @get('state') == 'playing'
      data = {time: @_time(), progress: @_progress()}

      # When progress reaches one, it means the end of the timeline (specified by duration) is reached,
      # simply loop back to the beginning
      if data.progress && data.progress > 1
        @trigger 'end'
        return

      # console.log data
      @set(data)

  _onStateChange: (timer,state,obj) ->
    if state == 'playing'
      if @previous('state') == 'paused'
        @setProgress(@get('progress'))

      if @previous('state') == 'stopped'
        @set({startTime: @curTime()})

    if state == 'stopped'
      @set({stopTime: @curTime()})