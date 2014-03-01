class

canvas = null
context = null
window.ang = null

window.onload = () ->
	canvas = document.getElementById "board"
	context = canvas.getContext "2d"
	window.ang = new Object({x: 400, y:300}, 30)
	requestAnimationFrame(mainLoop)

mainLoop = () ->
	#context.clearRect 0, 0, canvas.width, canvas.height
	#console.log canvas.width, canvas.height
	canvas.width = canvas.width
	ang.draw(context)
	ang.turn(1)
	requestAnimationFrame(mainLoop)	

window.requestAnimationFrame = do ->
	window.requestAnimationFrame or
	window.webkitrequestAnimationFrame or
	window.mozrequestAnimationFrame or
	(cback) -> window.setTimeout cback, 1000/60