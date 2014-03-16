dist2 = (p1, p2) ->
	Math.abs((p1.x-p2.x))*Math.abs((p1.x-p2.x)) + Math.abs((p1.y-p2.y))*Math.abs((p1.y-p2.y))

dist = (p1, p2) -> Math.sqrt(dist2(p1, p2))

Collision =
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