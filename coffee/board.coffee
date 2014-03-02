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


class PlaneMirror extends Mirror

class ConvexMirror extends Mirror

class ConcaveMirror extends Mirror

class LaserGun extends Turnable
	img: null

	draw: (context) ->
		drawer.polygon context, "fill", @angle, @pos, 3, 30

class Laser
	origin: null
	path: null

	constructor: (@origin={x: 0, y: 0}) ->
		@path = []

	addPoint: (p) ->
		@path.push p

	removePoint: (p) -> @path.pop

	clear: (start) ->
		@path = []
		@origin = start if start

	draw: (context) ->
		if @path.length > 0
			p1 = @origin
			for p2 in @path
				drawer.line(context, p1, p2)
				p1 = p2


window.PlaneMirror = PlaneMirror
window.LaserGun = LaserGun
window.Laser = Laser