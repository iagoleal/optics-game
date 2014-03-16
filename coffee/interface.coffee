class Button
	position: null
	click: null
	radius: 10

	constructor: (pos={x: 0, y:0}, @click) ->
		@position =
			x: pos.x
			y: pos.y
		click = (->null) if !click

	collided: (point) ->
		dist2(@position, point) <= @radius*@radius

	draw: (context) -> 
		drawer.arc context, "fill", @position, 0, 360, @radius, {color: '#fff'}


class Turner
	turnable: null

	constructor: (@turnable={x:0, y:0}) ->

	draw: (context) ->
		radius = switch
			when "radius" of @turnable
				@turnable.radius
			when "width" of @turnable
				@turnable.width/2
		console.log 111
		drawer.arc context, "fill", @turnable.position, 0, 360, radius+15, {color: "#fff"}
		drawer.arc context, "clip", @turnable.position, 0, 360, radius+3, {color: "rgba(0, 0, 0, 0)"}

window.Turner = Turner
