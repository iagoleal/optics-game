window.onload = () ->
	window.board = new Board "board"
	window.buttons = new Interface "buttons"
	
	board.setLevel(Levels.test)

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
			if a and a.turnable
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

	document.addEventListener 'mousemove', (e) =>
		pos = 
			x: e.pageX - board.canvas.offsetLeft
			y: e.pageY - board.canvas.offsetTop
		if longPress
			buttons.pointTo pos

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
