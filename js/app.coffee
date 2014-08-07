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

		paper.view.on 'frame', -> TWEEN.update()

		# @waveOps = new WaveOps()
		# @waveOps2 = new WaveOps()
		@waveSiners = [new WaveSiner(), new WaveSiner(), new WaveSiner(), new WaveSiner(), new WaveSiner(), new WaveSiner()]


		@rect = new paper.Rectangle(0, 0, 10, 10)
		@rect.stroke

		$('canvas').mousedown (e) =>
			@waveOps.drip(new paper.Point(e.offsetX, e.offsetY))
			@waveOps2.drip(new paper.Point(paper.view.size.width - e.offsetX, paper.view.size.height - e.offsetY))

		return
		test_func = =>
			pos = new paper.Point(
				Math.random() * paper.view.viewSize.width,
				paper.view.viewSize.height * 0.5
			)
			@waveOps.drip(pos, Math.random() * 30)
			setTimeout(test_func, 1000)
		setTimeout(test_func, 300)

