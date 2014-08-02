class @App extends Backbone.Model
	initialize: ->
		@setup()

	setup: ->
		# @controls = new Controls(duration: @timer.get('duration'))

		canvas = document.getElementById 'targetCanvas'
		paper.setup canvas

		path = new paper.Path()
		path.strokeColor = 'black'
		start = new paper.Point(100, 100)
		path.moveTo(start)
		path.lineTo(start.add([ 700, -50 ]))
		paper.view.draw()

	update: ->
		return if @get('paused') == true
		@trigger 'update'
		@draw()

		requestAnimationFrame =>
			@update()
	
	draw: ->
		# nothing here

