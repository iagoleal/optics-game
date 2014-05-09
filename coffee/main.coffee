class Board
	canvas: null
	context: null
	
	width: 0
	height: 0

	guns: null
	mirrors: null
	obstacles: null
	stars: null

	selectedGun: null

	shoted: false

	constructor: (cv) ->
		@canvas = document.getElementById(cv)
		@context = @canvas.getContext "2d"

		@width = @canvas.width
		@height = @canvas.height


		drawer.setOptions @context, {color: '#000', join: 'round'}

		@guns = []
		@mirrors = []
		@obstacles = []
		@stars = []

		@guns.push new LaserGun {x: @width/2, y: @height/2}, 0
		@guns.push new LaserGun {x: @width/3, y: @width/3}, 0


	shot: (pos) ->

		if @selectedGun
			star.glow = off for star in @stars
			@shoted = true
			@selectedGun.shot(pos)


	collisionEffect: (a, gun) ->
		if a and a.type is "Mirror"
			@reflect a, gun
		if a and a.type is "Star"
			a.glow = on
			gun.laser.advance()

	recalculate: () ->
		for gun in @guns
			if gun.laser.path.length >= 2
				star.glow = off for star in @stars
				gun.laser.clear gun.position, gun.front()

				a = @collided gun.laser.last()
				while !a or !(a and a.type is "Wall")
					#console.log a.type
					gun.laser.advance(1)
					@collisionEffect @collided gun.laser.last(), gun

				gun.laser.path[0] = gun.front()
		
	reflect: (mirror, gun) ->
		angle = mirror.reflect gun.laser.angle()

		pos = gun.laser.last()
		#slope = Math.abs(Math.tan(angle*Math.PI/180))
		pos.x -= 20*Math.cos(angle)
		pos.y -= 20*Math.sin(angle)
		gun.laser.addPoint pos


	collided: (pos) ->
		if pos.x <= 0 or pos.x >= @width or pos.y <= 0 or pos.y >= @height
			return {type: "Wall"}
		return obstacle for obstacle in @obstacles when obstacle.collided(pos)
		return mirror for mirror in @mirrors when mirror.collided(pos)
		return star for star in @stars when star.collided(pos)
		return gun for gun in @guns when gun.collided(pos)
		return null


	addMirror: (pos, angle=0, width=100) ->
		@mirrors.push new PlaneMirror pos, angle, width

	addStar: (pos, radius) ->
		@stars.push new Star pos, radius

	addWall: (pos, angle=0, width) ->
		@obstacles.push new Wall pos, angle, width

	selectGun: (pos) ->
		r = false
		for gun in @guns when gun.collided(pos)
			r = true
			@selectedGun = if @selectedGun is gun then null else gun
		return r



	draw: () ->
		#@canvas.width = @width
		@context.save()

		@context.setTransform(1, 0, 0, 1, 0, 0)
		@context.clearRect 0, 0, @width, @height

		@context.restore()
		
		@context.fillRect 0, 0, @width, @height

		mirror.draw @context for mirror in @mirrors
		obstacle.draw @context for obstacle in @obstacles
		for gun in @guns
			gun.laser.draw @context
			if @selectedGun is gun
				gun.draw @context, true
			else
				gun.draw @context

		star.draw @context for star in @stars


	animate: () ->
		# Every time function is executed, the laser advances a little bit
		for gun in @guns
			coll = @collided(gun.laser.last())
			if ! coll and @shoted
				i = 0
				while ! coll and i < 10
					gun.laser.advance()
					i++
					coll = @collided(gun.laser.last())
					@collisionEffect coll, gun
			else # if laser animation is finished, just do the laser maintenance
				if coll
					@collisionEffect coll, gun
				else
					@shoted = false# if @collided(@gun.laser.last()) is "wall"
					@recalculate()
		for m in @mirrors
			m.turn 0
		setTimeout => 
			@animate()
		, 1000/1000

class Interface
	width: 0
	height: 0

	context: null

	turner: null

	constructor: (cv) ->
		canvas = document.getElementById(cv)
		@context = canvas.getContext "2d"

		@width = canvas.width
		@height = canvas.height

	draw: () ->
		@context.clearRect 0, 0, @width, @height

		@context.fillStyle = "blue"
		@context.strokeStyle = "blue"
		#@context.beginPath()
		#@context.moveTo 0, 0
		#@context.rect 0, 0, @width-10, @height-100
		#@context.closePath()
		#@context.fill()

		@turner.draw @context if @turner


window.onload = () ->
	window.board = new Board "board"
	window.buttons = new Interface "buttons"
	window.board.addMirror {x: 600, y: 70}, Math.PI/4
	window.board.addMirror {x: 200, y: 70}, Geometry.rad(325)
	window.board.addMirror {x: 400, y: 70}, Geometry.rad(0)
	window.board.addMirror {x: 200, y: 600-70}, Geometry.rad(225)
	window.board.addMirror {x: 600, y: 600-70}, Geometry.rad(135)
	window.board.addMirror {x: 400, y: 600-70}, Geometry.rad(180)

	window.board.addMirror {x: 700, y: 300}, Geometry.rad(45)
	window.board.addWall {x: 100, y: 300}, Geometry.rad(270), 100

	window.board.addStar {x: 200, y: 350}, 10

	window.board.animate()

	clickTimer = false
	longPress = no

	#Click Event
	document.addEventListener 'mousedown', (e) =>
		pos = 
			x: e.pageX - board.canvas.offsetLeft
			y: e.pageY - board.canvas.offsetTop

		clickTimer = setTimeout -> 
			longPress = yes

			a = board.collided(pos)
			console.log a
			if a
				buttons.turner = new Turner a
		, 1000

	document.addEventListener 'mouseup', (e) =>
		pos = 
			x: e.pageX - board.canvas.offsetLeft
			y: e.pageY - board.canvas.offsetTop
		buttons.turner = null
		clearTimeout clickTimer
		unless longPress
			unless board.selectGun(pos)
				board.shot(pos)

		longPress = no

	requestAnimationFrame(mainLoop)	

mainLoop = () ->
	if typeof mainLoop.lastTime is 'undefined'
		mainLoop.lastTime = new Date().getTime()
	else
		fps = 1000/(new Date().getTime() - mainLoop.lastTime)
		document.getElementById("fps").innerHTML = fps.toFixed(2) + ' fps'
		mainLoop.lastTime = new Date().getTime()

	board.draw()
	buttons.draw()

	requestAnimationFrame(mainLoop)	

window.requestAnimationFrame = do ->
	window.requestAnimationFrame or
	window.webkitrequestAnimationFrame or
	window.mozrequestAnimationFrame or
	(cback) -> window.setTimeout cback, 1000/60
