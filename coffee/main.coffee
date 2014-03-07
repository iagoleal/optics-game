class Board
	canvas: null
	context: null
	bgContext: null
	
	width: 0
	height: 0

	gun: null
	mirrors: null
	laser: null

	constructor: (cv) ->
		@canvas = document.getElementById(cv)
		@context = @canvas.getContext "2d"
		bcanvas = document.getElementById('bground')
		@bgContext = bcanvas.getContext "2d"
		@width = @canvas.width
		@height = @canvas.height

		@context.fillStyle = 'white'
		@context.strokeStyle = 'white'

		@bgContext.fillStyle = 'black'
		@bgContext.fillRect 0, 0, @width, @height

		@gun = new LaserGun {x: @width/2, y: @height/2}, 0
		@laser = new Laser @gun.position
		@mirrors = []

	shot: (pos) ->
		dx = pos.x - @gun.position.x
		dy = pos.y - @gun.position.y
		slope = dy/dx

		@shoted = true
		@gun.angle = Math.atan2(dy, dx) * 180 / Math.PI
		console.log @gun.angle, slope
		
		@laser.clear @gun.front()

		###
		  4 |  1
 		---------
 		  3 |  2
		###
		pos.x = @gun.front().x
		pos.y = @gun.front().y
		if ! @collided(pos)
			#Slope is Infinity
			if dx is 0
				pos.x = @laser.last().x
				pos.y += if dy > 0 then 1 else -1
			else
				pos.x += if dx > 0 then 1 else -1
				pos.y += if dx > 0 then dy/dx else -dy/dx

			@laser.last pos
		m = @collided(pos)
		if m? and m.type is "Mirror"
			ang = m.reflect(pos, @gun.angle)

	#shot: (pos) ->

	collided: (pos) ->
		if pos.x <= 0 or pos.x >= @width or pos.y <= 0 or pos.y >= @height
			return true
		for m in @mirrors
			return m if m.collided(pos)
		return null


	addMirror: (pos, angle=0) ->
		@mirrors.push new PlaneMirror pos, angle

	draw: () ->
		@canvas.width = @canvas.width

		mirror.draw @context for mirror in @mirrors
		@gun.draw @context
		@laser.draw @context



	animate: () ->
		pos = @laser.last()
		if ! @collided(pos) and @shoted
			[dx, dy] = @laser.changeRate()
			#Slope is Infinity
			if dx is 0
				pos.x = @laser.last().x
				pos.y += if dy > 0 then 1 else -1
			else
				pos.x += if dx > 0 then 5 else -5
				pos.y += if dx > 0 then 5*dy/dx else -5*dy/dx

			@laser.last pos
		for m in @mirrors
			m.turn 0
		setTimeout => 
			@animate()
		, 1000/1000


window.onload = () ->
	window.board = new Board "board"
	window.board.addMirror {x: 100, y: 100}, 0
	window.board.animate()

	#Click Event
	document.getElementById('board').addEventListener 'click', (e) =>
		pos = 
			x: e.pageX - board.canvas.offsetLeft
			y: e.pageY - board.canvas.offsetTop
		
		board.shot(pos)

	requestAnimationFrame(mainLoop)	

mainLoop = () ->
	if typeof mainLoop.lastTime is 'undefined'
		mainLoop.lastTime = new Date().getTime()
	else
		fps = 1000/(new Date().getTime() - mainLoop.lastTime)
		document.getElementById("fps").innerHTML = fps.toFixed(2) + ' fps'
		mainLoop.lastTime = new Date().getTime()

	window.board.draw()
	requestAnimationFrame(mainLoop)	

window.requestAnimationFrame = do ->
	window.requestAnimationFrame or
	window.webkitrequestAnimationFrame or
	window.mozrequestAnimationFrame or
	(cback) -> window.setTimeout cback, 1000/60
