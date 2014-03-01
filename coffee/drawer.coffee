class Drawer
	angleMod: Math.PI/180

	rectangle: (context, type, angle, center, width, height) ->
		context.save()

		context.translate(center.x, center.y)
		context.rotate angle*@angleMod
		context.rect(-width/2, -height/2, width, height)

		if type is "stroke" then context.stroke() else context.fill()

		context.restore()

	polygon: (context, type, angle, center, sides, radius) ->
		context.save()
		
		context.translate(center.x, center.y)
		context.rotate (angle - 90)*@angleMod
		
		a = (Math.PI*2)/sides

		context.beginPath()
		context.moveTo radius, 0
		for i in [1..sides]
			context.lineTo radius*Math.cos(a*i), radius*Math.sin(a*i)
		context.closePath()

		if type is "stroke" then context.stroke() else context.fill()

		context.restore()

	image: (context, img, angle, center, width, height) ->
		context.save()

		context.translate(center.x, center.y)
		context.rotate angle*@angleMod

		context.drawImage(img, -width/2, -height/2, width, height)

		context.restore()

window.drawer = new Drawer
