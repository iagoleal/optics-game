class Object
	position: null
	angle: 0

	constructor: (@position={x:0, y:0},@angle=0) ->

	turn: (dgr) -> 
		@angle += dgr
		if @angle > 360
			@angle -= 360
		else if @angle < 0
			@angle += 360

	draw: (context) ->
		drawer.rectangle context, "fill", @angle, @position, 100, 100

class Mirror extends Object
	img: null


window.Mirror = Mirror
