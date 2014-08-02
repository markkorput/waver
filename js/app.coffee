class @App extends Backbone.Model
	initialize: ->
		@setup()

	setup: ->
		# @controls = new Controls(duration: @timer.get('duration'))

		canvas = document.getElementById 'targetCanvas'
		paper.setup canvas

		@waveOps = new WaveOps()

		paper.view.on 'frame', @update
		# resize event is not firing?!
		paper.view.on 'resize', @resize		

	update: =>
		return if @get('paused') == true
		@trigger 'update'
		@draw()
	
	draw: ->
		# console.log 'draw'

	resize: (e) =>
		console.log e 