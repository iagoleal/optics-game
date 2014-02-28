class Vector
	constructor: (@size) ->
		@array = Array()

	get: ->
		@array

	__change: (a, b) ->
		@array[a] = b

	change = (args...) ->
		__change i, arg for arg in args


class Position extends Vector
	constructor: (x,y) ->
		super(2)
		@array[0] = x
		@array[1] = y

	getx: ->
		@array[0]

	gety: ->
		@array[1]

	change: (x,y) ->
		@array[0] = x
		@array[1] = y
