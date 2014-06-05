module 'Physics'

class Physics.Vector
	x: 0
	y: 0

	constructor: (@x=0, @y=0) ->

	magnitude: (n) ->  
		d = Geometry.distance({x: 0, y:0}, {x: @x, y: @y})
		if n
			d = n
			@x = d * Math.cos(@angle())
			@y = d * Math.sin(@angle())
		return d

	angle: (t) ->
		a = Math.atan2(@y, @x)
		if t
			a = t
			@x = @magnitude * Math.cos(a)
			@y = @magnitude * Math.sin(a)
		return a

	@dotProduct: (v1, v2) ->
		(v1.x * v2.x) + (v1.y * v2.y)

	@crossProduct: (v1, v2) ->
		(v1.x * v2.y) - (v1.y * v2.x)



Physics.Optics = 
	reflec: () ->

Physics.Collision =
	rect: (point, rectPos, width, height, angle=0) ->
		#rotated rectangle collision
		c = Math.cos(-angle)
		s = Math.sin(-angle)

		rx = rectPos.x + c * (point.x - rectPos.x) - s * (point.y - rectPos.y)
		ry = rectPos.y + s * (point.x - rectPos.x) + c * (point.y - rectPos.y)

		return  rectPos.x - width/2 <= rx and 
				rectPos.x + width/2 >= rx and 
				rectPos.y - height/2 <= ry and 
				rectPos.y + height/2 >= ry

	circle: (point, center, radius) ->
		Geometry.dist2(center, point) <= radius*radius