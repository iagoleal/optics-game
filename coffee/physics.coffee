module 'Physics'

class Physics.Vector
	x: 0
	y: 0

	constructor: (@x=0, @y=0) ->

	magnitude: (n) ->  
		d = Geometry.distance({x: 0, y:0}, {x: @x, y: @y})
		if n
			d = n
			@x = d * Math.cos(@angle()*Math.PI/180)
			@y = d * Math.sin(@angle()*Math.PI/180)
		return d

	angle: (t) ->
		a = Math.atan2(@y, @x)*180/Math.PI
		if t
			a = t
			@x = @magnitude * Math.cos(a*Math.PI/180)
			@y = @magnitude * Math.sin(a*Math.PI/180)
		return a



Physics.Optics = 
	reflec: () ->

Physics.Collision =
	rect: (point, rectPos, width, height, angle=0) ->
		#rotated rectangle collision
		c = Math.cos(-angle*Math.PI/180)
		s = Math.sin(-angle*Math.PI/180)

		rx = rectPos.x + c * (point.x - rectPos.x) - s * (point.y - rectPos.y)
		ry = rectPos.y + s * (point.x - rectPos.x) + c * (point.y - rectPos.y)

		return  rectPos.x - width/2 <= rx and 
				rectPos.x + width/2 >= rx and 
				rectPos.y - height/2 <= ry and 
				rectPos.y + height/2 >= ry

	circle: (point, center, radius) ->
		dist2(center, point) <= radius*radius