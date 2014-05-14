module 'Mirror'

class Mirror.Plane extends Geometry.Rectangle
	type: "Mirror"
	height: 4

	reflect: (ang) ->
		mangle = if @angle <= Math.PI then @angle else (@angle-Math.PI)
		mangle = @angle - Math.PI/2

		console.log "a", (2*Math.PI - ang + 2*mangle)*180/Math.PI

		return Geometry.reduceAngle( 2*Math.PI - ang + 2*mangle )


	draw: (context) ->
		drawer.rectangle context, "stroke", @angle, @position, @width, @height, {color: 'white', shadow: {color:'#fff', offsetX: 0, offsetY: 0, blur: 10}}
		drawer.distance context, (@angle), @position, 100, {color: 'white'}