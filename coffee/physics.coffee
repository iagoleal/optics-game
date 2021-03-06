module 'Physics'

class Physics.Vector
	origin: null
	magnitude: 0
	angle: 0

	constructor: (@magnitude=0, @angle=0, o={}) ->
		@origin = {}
		@origin.x = o.x or 0
		@origin.y = o.y or 0


	position: -> 
		x: @origin.x + @magnitude*Math.cos(@angle)
		y: @origin.y + @magnitude*Math.sin(@angle)



Physics.Optics = 
	reflect: () ->

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