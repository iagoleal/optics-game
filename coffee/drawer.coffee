class Drawer
	rectangle: (context, type, angle, center, width, height) ->
		context.save()

		context.translate(center.x, center.y)
		context.rotate(angle*Math.PI/180)
		context.rect(-width/2, -height/2, width, height)

		if type is "stroke" then context.stroke() else context.fill()

		context.restore()

	img: (context, image, angle, center, width, height) ->
		width = width || image.width
		height = height || image.height
		context.save()

		context.translate(center.x, center.y)
		context.rotate(angle*Math.PI/180)
		context.drawImage(image, -width/2, -height/2, width, height)

		context.restore()


window.drawer = new Drawer
