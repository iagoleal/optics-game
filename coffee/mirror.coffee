module 'Mirror'

class Mirror.Plane extends Geometry.Rectangle
	type: "Mirror"
	height: 10

	constructor: (pos={x:0, y:0}, @angle=0,  @width=100, @turnable=true) ->
		super pos, @angle, @width, @height

	reflect: (ang) ->
		mangle = if @angle <= Math.PI then @angle else (@angle-Math.PI)
		mangle = @angle - Math.PI/2

		console.log "a", (2*Math.PI - ang + 2*mangle)*180/Math.PI

		return Geometry.reduceAngle( Math.PI - ang + 2*mangle )


	draw: (context) ->
		drawer.rectangle context, "stroke", @angle, @position, @width, @height, {color: 'white', shadow: {color:'#fff', offsetX: 0, offsetY: 0, blur: 10}}
		drawer.distance context, (@angle), @position, 100, {color: 'white'}