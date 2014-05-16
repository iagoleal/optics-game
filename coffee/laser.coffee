
#Gun that shots a nice laser
class LaserGun extends Geometry.Turnable
	radius: 30
	laser: null
	img: null

	constructor: (pos={x:0, y:0},@angle=0, @turnable=true, @img) ->
		@position =
			x: pos.x
			y: pos.y
		@laser = new Laser

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
		@laser.clear @position, @front()
		@laser.advance(1)

	collided: (p) ->
		Physics.Collision.circle(p, @position, @radius)

	draw: (context, selected) ->

		#drawer.image context, @img, @position.x, @position.y, @angle, @position

		color = '#ffffff'
		if selected
			color = '#ff0000'
		drawer.polygon(context, "stroke", @angle, @position, 3, @radius, {width: 1, color: color})

# The laser itself
class Laser
	path: null
	color: null
	velocity: null

	constructor: (origin={x:0, y: 0}) ->
		@path = []
		@color = 
			r: 255
			g: 255
			b: 255
		@velocity = new Physics.Vector
		@velocity.magnitude 1
		@path.push(origin) if origin

	addPoint: (p) ->
		@path.push p
		@velocity.angle @angle(p)

	angle: (point=-1) ->
		[dy, dx] = @changeRate(point)

		return Math.atan2(dy, dx)

	changeRate: (point=-1) ->
		point = @path.length + point if point < 0
		if point < @path.length and point > 0
			dx = @path[point].x - @path[point-1].x
			dy = @path[point].y - @path[point-1].y

			return [dy, dx]
		return [0, 0]

	last: (p) -> 
		if p
			if @path.length > 1
				@path[@path.length-1] = p
			else
				@path[@path.length] = p
		x: @path[@path.length-1].x
		y: @path[@path.length-1].y

	advance: () ->
		@path[@path.length-1].x += @velocity.magnitude()*Math.cos(@angle())
		@path[@path.length-1].y += @velocity.magnitude()*Math.sin(@angle())

	clear: () ->
		@path = []
		@path.push point for point in arguments


	draw: (context) ->
		if @path.length > 1
			for i in [5..0]
				lineWidth = (i+1)*4-2
				color = if i is 0 then '#fff' else "rgba(#{@color.r}, #{@color.g}, #{@color.b}, 0.2)"
				drawer.path context, @path, {color: color, width: lineWidth}

window.LaserGun = LaserGun