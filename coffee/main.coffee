class Board
	canvas: null
	context: null

	mirrors: null

	constructor: (cv) ->
		@canvas = document.getElementById(cv)
		@context = @canvas.getContext "2d"

		@mirrors = []

	addMirror: (x, y, angle=0) ->
		@mirrors.push new Mirror x, y, angle

	draw: () ->
		@canvas.width = @canvas.width
		for m in @mirrors
			m.draw @context

	animate: () ->
		for m in @mirrors
			m.turn 1
		setTimeout => 
			@animate()
		, 1000/1000

window.onload = () ->
	window.board = new Board "board"
	window.board.addMirror(100, 100, 20)
	window.board.animate()
	requestAnimationFrame(mainLoop)

mainLoop = () ->
	if typeof mainLoop.lastTime is 'undefined'
		mainLoop.lastTime = new Date().getTime()
	else
		fps = 1000/(new Date().getTime() - mainLoop.lastTime)
		document.getElementById("fps").innerHTML = fps.toFixed(2) + ' fps'
		mainLoop.lastTime = new Date().getTime()

	board.draw()
	requestAnimationFrame(mainLoop)	

window.requestAnimationFrame = do ->
	window.requestAnimationFrame or
	window.webkitrequestAnimationFrame or
	window.mozrequestAnimationFrame or
	(cback) -> window.setTimeout cback, 1000/60