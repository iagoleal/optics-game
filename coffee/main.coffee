class Board
	canvas: null
	context: null

	gun: null
	mirrors: null

	constructor: (cv) ->
		@canvas = document.getElementById(cv)
		@context = @canvas.getContext "2d"

		@gun = new LaserGun {x: 100, y: 400}, 0
		@mirrors = []

	addMirror: (pos, angle=0) ->
		@mirrors.push new Mirror pos, angle

	draw: () ->
		@canvas.width = @canvas.width
		for m in @mirrors
			m.draw @context
		@gun.draw @context

	animate: () ->
		for m in @mirrors
			m.turn 1
		setTimeout => 
			@animate()
		, 1000/1000


window.onload = () ->
	window.board = new Board "board"
	window.board.addMirror {x: 100, y: 100}, 0
	window.board.animate()

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