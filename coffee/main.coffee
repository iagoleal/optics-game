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
		@context.lineJoin = "bevel"
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
		
		@laser.clear @gun.position, @gun.front()
		@laser.advance()
		@laser.path[0] = @gun.front()


	recalculate: () ->
		if @laser.path.length >= 2
			@laser.clear @gun.position, @gun.front()

			while @collided(@laser.last()) != "wall"
				@laser.advance(1)
				a = @collided(@laser.last())
				if a and a.type is "Mirror"
					@reflect a
		
			@laser.path[0] = @gun.front()
		
	reflect: (mirror) ->
		angle = mirror.reflect @laser.angle()
		#console.log @laser.angle(), angle
		pos = @laser.last()
		#slope = Math.abs(Math.tan(angle*Math.PI/180))
		pos.x -= 20*Math.cos(angle*Math.PI/180)
		pos.y -= 20*Math.sin(angle*Math.PI/180)
		@laser.addPoint pos


	collided: (pos) ->
		if pos.x <= 0 or pos.x >= @width or pos.y <= 0 or pos.y >= @height
			return "wall"
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
		# Every time function is executed, the laser advances a little bit
		coll = @collided(@laser.last())
		if false and ! coll and @shoted
			i = 0
			while ! coll and i < 5
				@laser.advance(1)
				i++
		else # if laser animation is finished, just do the laser maintenance
			if coll and coll.type is "Mirror"
				@reflect coll
			else
				@shoted = false# if @collided(@laser.last()) is "wall"
				@recalculate()
		for m in @mirrors
			m.turn 0
		setTimeout => 
			@animate()
		, 1000/1000


window.onload = () ->
	window.board = new Board "board"
	window.board.addMirror {x: 600, y: 70}, 30
	window.board.addMirror {x: 200, y: 70}, 0
	window.board.addMirror {x: 400, y: 70}, 0
	window.board.addMirror {x: 200, y: 600-70}, 210
	window.board.addMirror {x: 600, y: 600-70}, 180

	window.board.addMirror {x: 700, y: 300}, 90
	window.board.addMirror {x: 100, y: 300}, 270
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
