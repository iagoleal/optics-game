module 'Geometry'

Geometry.dist2 = (p1, p2) ->
	Math.abs((p1.x-p2.x))*Math.abs((p1.x-p2.x)) + Math.abs((p1.y-p2.y))*Math.abs((p1.y-p2.y))

Geometry.distance = (p1, p2) -> Math.sqrt(Geometry.dist2(p1, p2))

Geometry.rad = (ang) ->
	ang * Math.PI/180

Geometry.reduceAngle = (ang) ->
	if ang > 0
		while ang >= 2*Math.PI
			ang -= 2*Math.PI
	else
		while ang <= -2*Math.PI
			ang += 2*Math.PI
		ang = 2*Math.PI + ang 
	return ang

class Geometry.Turnable
	position: null
	angle: 0
	turnable: on #Says if you can turn the object or not

	constructor: (pos={x:0, y:0},@angle=0, @turnable: true) ->
		@position =
			x: pos.x
			y: pos.y

	turn: (dgr) -> 
		@angle += dgr

		if @angle > 2*Math.PI
			@angle -= 2*Math.PI
		else if @angle < 0
			@angle += 2*Math.PI
		return this

	collided: (point) ->
	draw: (context) ->

class Geometry.Rectangle extends Geometry.Turnable
	width: 100
	height: 10

	constructor: (pos={x:0, y:0}, @angle=0,  @width=100, @height=10) ->
		super pos, @angle


	collided: (point) ->
		Physics.Collision.rect(point, @position, @width, @height, @angle)

	draw: (context) ->
		drawer.rectangle context, "fill", @angle, @position, @width, @height, {color: '#aaa'}