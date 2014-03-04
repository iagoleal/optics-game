class Turnable
	position: null
	angle: 0

	constructor: (@position={x:0, y:0},@angle=0) ->

	turn: (dgr) -> 
		@angle += dgr

		if @angle > 360
			@angle -= 360
		else if @angle < 0
			@angle += 360
		return this

class Mirror extends Turnable
	img: null
	width: 100
	height: 10
	type: "Mirror"



class PlaneMirror extends Mirror

	collided: (point) ->
		c = Math.cos(-@angle*Math.PI/180)
		s = Math.sin(-@angle*Math.PI/180)

		rx = @position.x + c * (point.x - @position.x) - s * (point.y - @position.y)
		ry = @position.y + s * (point.x - @position.x) + c * (point.y - @position.y)

		return  @position.x - @width/2 <= rx and 
				@position.x + @width/2 >= rx and 
				@position.y - @height/2 <= ry and 
				@position.y + @height/2 >= ry
		# Collision works, but only on static mirror
		# Need to recalculate collision point every time laser is shoot

	reflect: (point, ang) ->
		if @collided point
			return 360 - ang - 2*@angle 
		return null
	draw: (context) ->
		drawer.rectangle context, "fill", @angle, @position, @width, @height, {color: 'black', shadow: {color:'#fff', offsetX: 0, offsetY: 0, blur: 10}}
		drawer.distance context, (45+@angle), @position, 100, {color: 'white'}

class ConvexMirror extends Mirror

class ConcaveMirror extends Mirror

class LaserGun extends Turnable
	radius: 30
	img: null

	front: () ->
		x: @position.x + @radius*Math.cos(@angle*Math.PI/180)
		y: @position.y + @radius*Math.sin(@angle*Math.PI/180)

	draw: (context) ->
		drawer.polygon(context, "stroke", @angle, @position, 3, @radius, {width: 1, color:'white'})

class Laser
	path: null

	constructor: (origin) ->
		@path = []
		@path.push(origin) if origin


	addPoint: (p) ->
		@path.push p

	end: (p) -> 
		a = @path[@path.length-1]
		@path[@path.length] = p if p?
		return a

	clear: (origin) ->
		@path = []
		@path.push(origin) if origin

	draw: (context) ->
		if @path.length > 1
			drawer.path context, @path, {color: '#ddeeff', width: 5, shadow: {color: '#a00', offsetX: 0, offsetY: 0, blur: 25}}


window.PlaneMirror = PlaneMirror
window.LaserGun = LaserGun
window.Laser = Laser