module 'Mirror'

class Mirror.Plane extends Geometry.Rectangle
	type: "Mirror"
	height: 10

	constructor: (pos={x:0, y:0}, @angle=0,  @width=100, @turnable=true) ->
		super pos, @angle, @width, @height

	reflect: (ang) ->
		Geometry.reduceAngle(2*@angle - ang)


	draw: (context) ->
		drawer.rectangle context, "stroke", @angle, @position, @width, @height, {color: 'white', shadow: {color:'#fff', offsetX: 0, offsetY: 0, blur: 10}}
		drawer.distance context, (@angle), @position, 100, {color: 'white'}