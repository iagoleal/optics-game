class Board
	canvas: null
	context: null
	#bgContext: null
	
	width: 0
	height: 0

	gun: null
	mirrors: null
	obstacles: null
	stars: null

	shoted: false

	constructor: (cv) ->
		@canvas = document.getElementById(cv)
		@context = @canvas.getContext "2d"
		#bcanvas = document.getElementById('bground')
		#@bgContext = bcanvas.getContext "2d"
		@width = @canvas.width
		@height = @canvas.height

		drawer.setOptions @context, {color: '#000', join: 'round'}

		@gun = new LaserGun {x: @width/2, y: @height/2}, 0
		@mirrors = []
		@obstacles = []
		@stars = []

	shot: (pos) ->
		dx = pos.x - @gun.position.x
		dy = pos.y - @gun.position.y

		star.glow = off for star in @stars
		@shoted = true
		@gun.angle = Math.atan2(dy, dx) * 180 / Math.PI
		
		# Debug reasons only
		console.log @gun.angle, dy/dx
		
		@gun.laser.clear @gun.position, @gun.front()
		@gun.laser.advance(1)
		#@gun.laser.path[0] = @gun.front()


	recalculate: () ->
		if @gun.laser.path.length >= 2
			star.glow = off for star in @stars
			@gun.laser.clear @gun.position, @gun.front()

			a = @collided @gun.laser.last()
			while !a or !(a and a.type is "Wall")
				#console.log a.type
				@gun.laser.advance(1)
				a = @collided @gun.laser.last() 
				if a and a.type is "Mirror"
					@reflect a
				if a and a.type is "Star"
					a.glow = on

			@gun.laser.path[0] = @gun.front()
		
	reflect: (mirror) ->
		angle = mirror.reflect @gun.laser.angle()

		pos = @gun.laser.last()
		#slope = Math.abs(Math.tan(angle*Math.PI/180))
		pos.x -= 20*Math.cos(angle*Math.PI/180)
		pos.y -= 20*Math.sin(angle*Math.PI/180)
		@gun.laser.addPoint pos


	collided: (pos) ->
		if pos.x <= 0 or pos.x >= @width or pos.y <= 0 or pos.y >= @height
			return {type: "Wall"}
		return obstacle for obstacle in @obstacles when obstacle.collided(pos)
		return mirror for mirror in @mirrors when mirror.collided(pos)
		return star for star in @stars when star.collided(pos)
		return null


	addMirror: (pos, angle=0, width=100) ->
		@mirrors.push new PlaneMirror pos, angle

	addStar: (pos, radius) ->
		@stars.push new Star pos, radius

	addWall: (pos, angle=0, width) ->
		@obstacles.push new Wall pos, angle, width
	draw: () ->
		@canvas.width = @canvas.width
		@context.fillRect 0, 0, @width, @height

		mirror.draw @context for mirror in @mirrors
		obstacle.draw @context for obstacle in @obstacles
		@gun.draw @context
		star.draw @context for star in @stars
		@gun.laser.draw @context


	animate: () ->
		# Every time function is executed, the laser advances a little bit
		coll = @collided(@gun.laser.last())
		if ! coll and @shoted
			i = 0
			while ! @collided(@gun.laser.last()) and i < 10
				@gun.laser.advance(1)
				i++
		else # if laser animation is finished, just do the laser maintenance
			if coll and coll.type is "Mirror"
				@reflect coll
			else if coll and coll.type is "Star"
				coll.glow = on
				@gun.laser.advance(coll.radius*2)
			
			else
				@shoted = false# if @collided(@gun.laser.last()) is "wall"
				@recalculate()
		for m in @mirrors
			m.turn 0
		setTimeout => 
			@animate()
		, 1000/1000


window.onload = () ->
	window.board = new Board "board"
	window.board.addMirror {x: 600, y: 70}, 45
	window.board.addMirror {x: 200, y: 70}, 325
	window.board.addMirror {x: 400, y: 70}, 0
	window.board.addMirror {x: 200, y: 600-70}, 225
	window.board.addMirror {x: 600, y: 600-70}, 135
	window.board.addMirror {x: 400, y: 600-70}, 180

	window.board.addMirror {x: 700, y: 300}, 90
	window.board.addWall {x: 100, y: 300}, 270, 100

	window.board.addStar {x: 200, y: 350}, 10

	window.board.animate()

	clickTimer = false
	longPress = no

	#Click Event
	document.getElementById('board').addEventListener 'mousedown', (e) =>
		pos = 
			x: e.pageX - board.canvas.offsetLeft
			y: e.pageY - board.canvas.offsetTop

		clickTimer = setTimeout -> 
			longPress = yes
			console.log "BABU"
		, 1000
	document.getElementById('board').addEventListener 'mouseup', (e) =>
		pos = 
			x: e.pageX - board.canvas.offsetLeft
			y: e.pageY - board.canvas.offsetTop

		clearTimeout clickTimer
		board.shot(pos) unless longPress
		longPress = no

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
