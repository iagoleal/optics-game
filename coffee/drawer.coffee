class Drawer
	angleMod: Math.PI/180

	setOptions: (context, options) ->
		for index, option of options
			switch index
				when "color" 
					context.strokeStyle = option
				when "width"
					context.lineWidth = option
				when "shadow"
					for j, shadowOption of option
						switch j
							when "blur"
								context.shadowBlur = shadowOption
							when "color"
								context.shadowColor = shadowOption
							when "offsetX"
								context.shadowOffsetX = shadowOption
							when "offsetY"
								context.shadowOffsetY = shadowOption


	line: (context, start, end, options={}) ->

		@setOptions(context, options)

		context.beginPath()
		context.moveTo start.x, start.y
		context.lineTo end.x, end.y
		context.closePath()

		context.stroke()

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
		context.rotate (angle)*@angleMod
		
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
