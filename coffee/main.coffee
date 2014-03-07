class Board
	canvas: null
	context: null
	bgContext: null
	
	width: 0
	height: 0

	gun: null
	mirrors: null
	laser: null

	shoted: false

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

		@shoted = true
		@gun.angle = Math.atan2(dy, dx) * 180 / Math.PI
		
		# Debug only
		console.log @gun.angle, dy/dx
		
		@laser.clear @gun.position

		@laser.last @gun.front()
		@laser.advance()
		@laser.path[0] = @gun.front()

		m = @collided(pos)
		if m? and m.type is "Mirror"
			ang = m.reflect(pos, @gun.angle)

	recalculate: () ->
		if @laser.path.length >= 2
			@laser.clear @gun.position
			@laser.last @gun.front()
			while ! @collided(@laser.last())
				@laser.advance(1)
		
			@laser.path[0] = @gun.front()


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
		# Get the position of the laser's end
		# Every time loop is executed, the laser advances a little bit
		if ! @collided(@laser.last()) and @shoted
			@laser.advance()
		else 
			@shoted = false
			@recalculate()
		for m in @mirrors
			m.turn 1
		setTimeout => 
			@animate()
		, 1000/100


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
