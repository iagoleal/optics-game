class Object
	x: 0
	y: 0
	angle: 0

	constructor: (@x=0, @y=0, @angle=0) ->

	turn: (dgr) -> 
		@angle += dgr
		if @angle > 360
			@angle -= 360
		else if @angle < 0
			@angle += 360

	draw: (context) ->
		drawer.rectangle context, "fill", @angle, {x: @x, y: @y }, 100, 100

class Mirror extends Object
	img: null

	constructor: (image, @x=0, @y=0, @angle=0) ->
		@img = new Image
		@img.src = image

	draw: (context) ->
		drawer.image context, @img, @angle, {x: @x, y: @y }

window.Object = Object