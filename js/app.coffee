class @App extends Backbone.Model
	initialize: ->
		@setup()

	setup: ->
		@controls = new Controls()
		@controls.on 'toggle-playing', (val) ->
			if val
				paper.view.play()
			else
				paper.view.pause()
				console.log 'paused'

		canvas = document.getElementById 'targetCanvas'
		paper.setup canvas

		@waveOps = new WaveOps()

		@rect = new paper.Rectangle(0, 0, 10, 10)
		@rect.stroke

		$('canvas').mousedown (e) =>
			@waveOps.drip(new paper.Point(e.offsetX, e.offsetY), 200+Math.random()*100)

		return
		test_func = =>
			pos = new paper.Point(
				Math.random() * paper.view.viewSize.width,
				paper.view.viewSize.height * 0.5
			)
			@waveOps.drip(pos, Math.random() * 30)
			setTimeout(test_func, 1000)
		setTimeout(test_func, 300)