module 'Laser'

#Gun that shots a nice laser
class LaserGun extends Geometry.Turnable
	radius: 30
	laser: null
	img: null

	constructor: (pos={x:0, y:0},@angle=0, @turnable=true, laser_t) ->
		@position =
			x: pos.x
			y: pos.y
		console.log laser_t
		@laser = switch laser_t
			when "short"
				new Laser.Short
			else
				new Laser.Long

	front: () ->
		x: @position.x + @radius*Math.cos(@angle)
		y: @position.y + @radius*Math.sin(@angle)

	shot: (pos) ->
		if @turnable
			#Set slope of first line
			dy = pos.y - @position.y
			dx = pos.x - @position.x
			# Get angle from slope
			@angle = Math.atan2(dy, dx) 
			# Debug reasons only
			console.log @angle*180/Math.PI, dy/dx


		#Shot laser
		@laser.shot(@front(), @angle)

	collided: (p) ->
		Physics.Collision.circle(p, @position, @radius)

	draw: (context, selected) ->

		#drawer.image context, @img, @position.x, @position.y, @angle, @position

		color = '#ffffff'
		if selected
			color = '#ff0000'
		drawer.polygon(context, "stroke", @angle, @position, 3, @radius, {width: 1, color: color})


class Laser.Base
	path: null
	color: null
	velocity: 0

	constructor: () ->
		@path = []
		@color = 
			r: 255
			g: 255
			b: 255
		@velocity = 3

	angle: () ->
		@path[@path.length-1].angle

	clear: () ->
		@path = []
		#@path.push point for point in arguments

	last: () -> 
		if @path.length
			return @path[@path.length-1].position() 

	shot: (p, angle) ->
		@clear()
		@addPoint(p, angle)

	advance: () ->
	addPoint: () ->
	draw: () ->

# The most used laser
class Laser.Long extends Laser.Base

	addPoint: (p, angle) ->
		@path.push new Physics.Vector @velocity+1, angle, p

	advance: () ->
		if @path.length >= 1
			@path[@path.length-1].magnitude += @velocity

	draw: (context) ->
		if @path.length
			for i in [5..0]
				lineWidth = (i+1)*4-2
				color = if i is 0 then '#fff' else "rgba(#{@color.r}, #{@color.g}, #{@color.b}, 0.2)"
				drawer.path context, @path ,{color: color, width: lineWidth}

class Laser.Short extends Laser.Base
	size: 0

	constructor: (@size=20) ->
		super

	addPoint: (p, angle) ->
		@path = []
		@path.push new Physics.Vector @size, angle, p

	advance: () ->
		for ray in @path
			ray.origin.x += @velocity*Math.cos(ray.angle)
			ray.origin.y += @velocity*Math.sin(ray.angle)

	draw: (context) ->
		for ray in @path 
			for i in [5..0]
				lineWidth = (i+1)*4-2
				color = if i is 0 then '#fff' else "rgba(#{@color.r}, #{@color.g}, #{@color.b}, 0.2)"
				drawer.line context, ray.origin, ray.position() ,{color: color, width: lineWidth}	

window.LaserGun = LaserGun