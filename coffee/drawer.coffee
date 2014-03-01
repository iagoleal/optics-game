class Drawer
	rect: (context, type, angle, center, width, height) ->
		context.save()

		context.translate(center.x, center.y)
		context.rotate(angle*Math.PI/180)
		context.rect(-width/2, -height/2, width, height)

		if type is "stroke" then context.stroke() else context.fill()

		context.restore()

window.drawer = new Drawer
