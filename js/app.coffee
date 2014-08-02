class @App extends Backbone.Model
	initialize: ->
		@setup()

	setup: ->
		# @controls = new Controls(duration: @timer.get('duration'))
		canvas = document.getElementById 'targetCanvas'
		paper.setup canvas

		@waveOps = new WaveOps()
		test_func = =>
			@waveOps.drip(Math.random() * paper.view.viewSize.width, Math.random() * 700)
			setTimeout(test_func, 1000)
		setTimeout(test_func, 300)