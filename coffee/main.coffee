class Board
	canvas: null
	context: null
	
	width: 0
	height: 0

	gun: null
	mirrors: null
	laser: null

	constructor: (cv) ->
		@canvas = document.getElementById(cv)
		@context = @canvas.getContext "2d"
		@width = @canvas.width
		@height = @canvas.height
		#@canvas.style.width = window.innerWidth + 'px'
		#@canvas.style.height = window.innerHeight + 'px'

		@gun = new LaserGun {x: @width/2, y: @height/2}, 0
		@laser = new Laser @gun.pos
		@mirrors = []

	shot: (pos) ->
		dx = pos.x - @gun.pos.x
		dy = pos.y - @gun.pos.y

		@gun.angle = Math.atan2(dy, dx) * 180 / Math.PI

		console.log @gun.angle, dy/dx
		@laser.clear()

		while ! @collision(pos)
			#pos.x += if dx > 0 and dy < 0 then 1 else -1
			#pos.y += if dx > 0 then dy/dx else -(dy/dx)
			switch
				#Slope is Infinity
				when dx is 0
					pos.x = @gun.pos.x
					pos.y = if dy > 0 then @height else 0
				# 1st Quadrant
				when dx > 0 and dy >= 0
					pos.x += 1
					pos.y += dy/dx
				# 4rd Quadrant
				when dx > 0 and dy < 0
					pos.x += 1
					pos.y += dy/dx
				# 3rd Quadrant
				when dx < 0 and dy <= 0
					pos.x -= 1
					pos.y -= dy/dx
				# 2nd Quadrant
				when dx < 0 and dy > 0
					pos.x -= 1
					pos.y -= dy/dx
				else

		@laser.addPoint pos

	collision: (pos) ->
		if pos.x <= 0 or pos.x >= @width or pos.y <= 0 or pos.y >= @height
			return true
		return false


	addMirror: (pos, angle=0) ->
		@mirrors.push new PlaneMirror pos, angle

	draw: () ->
		@context.clearRect 0, 0, @width, @height
		for m in @mirrors
			m.draw @context
		@gun.draw @context
		@laser.draw @context

	animate: () ->
		for m in @mirrors
			m.turn 1
		setTimeout => 
			@animate()
		, 1000/100


window.onload = () ->
	window.board = new Board "board"
	window.board.addMirror {x: 100, y: 100}, 0
	window.board.animate()

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
