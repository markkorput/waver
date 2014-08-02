class @Controls extends Backbone.Model
	initialize:  ->
		@destroy()

		$(document).on 'mousedown', @mousedown
		$(document).on 'keydown', @keydown

		@gui = new dat.GUI()

		@data = new ((model) ->
			# @Stripes = => 
			@timeline = 0
			@loop = true
			@playing = true
			@duration = model.get('duration') || 10000)(this)

		folder = @gui.addFolder 'Animation'
		folder.open()

		item = folder.add(@data, 'playing')
		item.listen()
		item.onChange (val) => @trigger('toggle-playing', val)

		item = folder.add(@data, 'timeline', 0, 100)
		item.listen()
		item.onChange (val) => @trigger('timeline', val/100) # communicate in 0.0 - 1.0 ranges with outside

		item = folder.add(@data, 'loop')
		item.listen()
		item.onChange (val) => @trigger('toggle-loop', val)

		item = folder.add(@data, 'duration', 0, 50000)
		item.listen()
		item.onChange (val) => @trigger('duration', val) # communicate in 0.0 - 1.0 ranges with outside

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


