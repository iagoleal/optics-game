class Drawer
	angleMod: Math.PI/180

	setOptions: (context, type, options) ->
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

	arc: (context, type, center, start, end, radius, options={}) ->
		context.save()
		@setOptions(context, 'type', options)

		context.beginPath()
		context.arc center.x, center.y, radius, start*@angleMod, end*@angleMod
		
		if type is "stroke" then context.stroke() else context.fill()
		
		context.restore()

	line: (context, start, end, options={}) ->
		context.save()
		
		@setOptions(context, 'stroke', options)

		context.beginPath()
		context.moveTo start.x, start.y
		context.lineTo end.x, end.y
		context.closePath()

		context.stroke()

		context.restore()

	distance: (context, angle, start, distance, options={}) ->
		context.save()

		@setOptions(context, 'stroke', options)

		context.translate(start.x, start.y)
		context.rotate angle*@angleMod

		context.beginPath()
		context.moveTo 0, 0
		context.lineTo distance, distance
		context.closePath()
		context.stroke()
		

		context.restore()

	path: (context, points, options={}) ->
		context.save()
		
		@setOptions(context, 'stroke', options)

		context.beginPath()
		context.moveTo points[0].x, points[0].y
		for p in points[1..]
			context.lineTo p.x, p.y

		context.stroke()
		context.closePath()

		context.restore()

	rectangle: (context, type, angle, center, width, height, options={}) ->
		context.save()

		@setOptions(context, type, options)

		context.translate(center.x, center.y)
		context.rotate angle*@angleMod
		context.rect(-width/2, -height/2, width, height)

		if type is "stroke" then context.stroke() else context.fill()

		context.restore()

	polygon: (context, type, angle, center, sides, radius, options={}) ->
		context.save()

		@setOptions(context, type, options)
		
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


window.drawer = new Drawer
