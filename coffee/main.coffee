canvas = null
context = null
ang = 0

window.onload = () ->
	canvas = document.getElementById "board"
	context = canvas.getContext "2d"
	requestAnimationFrame(mainLoop)

mainLoop = () ->
	#context.clearRect 0, 0, canvas.width, canvas.height
	#console.log canvas.width, canvas.height
	canvas.width = canvas.width
	drawer.rect context, "fill", ang, {x: 400, y: 300 }, 100, 100
	ang++
	requestAnimationFrame(mainLoop)	

window.requestAnimationFrame = do ->
	window.requestAnimationFrame or
	window.webkitrequestAnimationFrame or
	window.mozrequestAnimationFrame or
	(cback) -> window.setTimeout cback, 1000/60