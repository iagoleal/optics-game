class Object
	position: null
	angle: 0

	constructor: (@position=null,@angle=0) ->

	turn: (dgr) -> 
		@angle += dgr
		if @angle > 360
			@angle -= 360
		else if @angle < 0
			@angle += 360

	draw: (context) ->
		drawer.rectangle context, "fill", @angle, { x: @position.x, y: @position.y }, 100, 100

class Mirror extends Object
	img: null

	constructor: (image, @position=null, @angle=0) ->
		@img = new Image
		@img.src = image

	draw: (context) ->
		drawer.image context, @img, @angle, {x: @position.x, y: @position.y }

window.Object = Object