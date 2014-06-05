class Drawer
	angleMod: 1

	setOptions: (context, options) ->
		for index, option of options
			switch index
				when "color" 
					context.strokeStyle = option
					context.fillStyle = option
				when "width"
					context.lineWidth = option
				when "join"
					context.lineJoin = option
				when "shadow"
					for j, shadowOption of option when option
						switch j
							when "blur"
								context.shadowBlur = shadowOption
							when "color"
								context.shadowColor = shadowOption
							when "offsetX"
								context.shadowOffsetX = shadowOption
							when "offsetY"
								context.shadowOffsetY = shadowOption

	arc: (context, type, center, start, end, radius, options={}) ->
		context.save()
		@setOptions(context, options)

		context.beginPath()
		context.arc center.x, center.y, radius, start*@angleMod, end*@angleMod
		#context.closePath()
		if type is "stroke" then context.stroke() else context.fill()
		
		context.restore()

	line: (context, start, end, options={}) ->
		context.save()
		
		@setOptions(context, options)

		context.beginPath()
		context.moveTo start.x, start.y
		context.lineTo end.x, end.y
		context.closePath()

		context.stroke()

		context.restore()

	#only for debugging
	distance: (context, angle, start, distance, options={}) ->
		context.save()

		@setOptions(context, options)

		context.translate(start.x, start.y)
		context.rotate angle*@angleMod

		context.beginPath()
		context.moveTo 0, 0
		context.lineTo 0, distance
		context.closePath()
		context.stroke()
		

		context.restore()

	#WOOOW LOT OF PATH TRUTO
	path: (context, points, options={}) ->
		context.save()
		
		@setOptions(context, options)

		context.beginPath()
		context.moveTo points[0].origin.x, points[0].origin.y
		for p in points[1..]
			context.lineTo p.origin.x, p.origin.y
		r = points[points.length-1].position()
		context.lineTo r.x, r.y
		context.stroke()
		context.closePath()

		context.restore()

	# im not obligated to explain that
	rectangle: (context, type, angle, center, width, height, options={}) ->
		context.save()

		@setOptions(context, options)

		context.translate(center.x, center.y)
		context.rotate angle*@angleMod
		context.rect(-width/2, -height/2, width, height)

		if type is "stroke" then context.stroke() else context.fill()

		context.restore()

	# neither that
	polygon: (context, type, angle, center, sides, radius, options={}) ->
		context.save()

		@setOptions(context, options)
		
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

	image: (context, img, x, y, angle, center, options = {}) ->
		context.save()
		
		@setOptions(context, options)

		context.translate(center.x, center.y)
		context.rotate (angle)*@angleMod

		context.drawImage(img, x, y)

		context. restore()

window.drawer = new Drawer
