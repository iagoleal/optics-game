class Turnable
	pos: null
	angle: 0

	constructor: (@pos={x:0, y:0},@angle=0) ->

	turn: (dgr) -> 
		@angle += dgr

		if @angle > 360
			@angle -= 360
		else if @angle < 0
			@angle += 360
		return this

	draw: (context) ->
		drawer.rectangle context, "fill", @angle, @pos, 100, 10

class Mirror extends Turnable
	img: null
	width: 100

	draw: (context) ->
		drawer.rectangle context, "fill", @angle, @pos, @width, 10

class PlaneMirror extends Mirror

class ConvexMirror extends Mirror

class ConcaveMirror extends Mirror

class LaserGun extends Turnable
	radius: 30
	img: null

	front: () ->
		x: @pos.x + @radius*Math.cos(@angle*Math.PI/180)
		y: @pos.y + @radius*Math.sin(@angle*Math.PI/180)



	draw: (context) ->
		drawer.polygon context, "fill", @angle, @pos, 3, @radius

class Laser
	origin: null
	path: null

	constructor: (@origin={x: 0, y: 0}) ->
		@path = []

	addPoint: (p) ->
		@path.push p

	end: (p) -> @path[@path.length]

	clear: (start) ->
		@path = []
		@origin = start if start

	draw: (context) ->
		if @path.length > 0
			p1 = @origin
			for p2 in @path
				drawer.line context, p1, p2, {color: 'red', width: 5, shadow: {color: '#a00', offsetX: 0, offsetY: 0, blur: 25}}
				p1 = p2
		drawer.setOptions context, {shadow: {blur: 0}}


window.PlaneMirror = PlaneMirror
window.LaserGun = LaserGun
window.Laser = Laser