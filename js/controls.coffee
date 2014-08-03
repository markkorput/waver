class @Controls extends Backbone.Model
	initialize:  ->
		@destroy()

		$(document).on 'mousedown', @mousedown
		$(document).on 'keydown', @keydown

		@gui = new dat.GUI()

		@data = new ((model) ->
			@playing = true
		)

		item = @gui.add(@data, 'playing')
		item.listen()
		item.onChange (val) => @trigger('toggle-playing', val)

	destroy: ->
		@trigger 'destroy'
		$(document).off 'mousedown keydown'

		if @gui
			@gui.destroy()
			@gui = undefined

	mousedown: (e) =>
		# console.log e
		# e.preventDefault()
		# e.stopPropagation()

	keydown: (e) =>
		# console.log e
		# e.preventDefault()
		# e.stopPropagation()

		# if event.which >= 48 && event.which <= 57 # 0 - 9
		@trigger 'reset' if(event.which == 27) # escape

		if event.which == 32 # SPACE
			@data.playing = (@data.playing != true)
			@trigger('toggle-playing', @data.playing)

		@trigger 'screenshot' if event.which == 13 # ENTER


