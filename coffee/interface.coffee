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

	pointTo: (pos) ->
		if @turner
			@turner.pointTo pos

	draw: () ->
		@context.clearRect 0, 0, @width, @height

		@context.fillStyle = "blue"
		@context.strokeStyle = "blue"

		@turner.draw @context if @turner

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
		drawer.arc context, "fill", @position, 0, 2*Math.PI, @radius, {color: '#fff'}


class Turner
	turnable: null
	radius: 0

	constructor: (@turnable={x:0, y:0}) ->
		@radius = switch
			when "radius" of @turnable
				@turnable.radius
			when "width" of @turnable
				@turnable.width/2

	pointTo: (pos) ->
		center = @turnable.position
		if Physics.Collision.circle(pos, center, @radius+40)# and ! Physics.Collision.circle(pos, center, @radius)
			dy = center.y - pos.y
			dx = center.x - pos.x
			# Sets the new angle
			# And shifts it by pi/2 so it's the center angle and not the border angle
			@turnable.angle = Math.atan2(dy, dx) + Math.PI/2

	draw: (context) ->
		radius = switch
			when "radius" of @turnable
				@turnable.radius
			when "width" of @turnable
				@turnable.width/2
		drawer.arc context, "stroke", @turnable.position, 0, 2*Math.PI, radius+20, {color: "rgba(255, 255, 255, 0.5", width: 15}
		#drawer.arc context, "clip", @turnable.position, 0, 360, radius+3, {color: "rgba(0, 0, 0, 0)"}

window.Turner = Turner
window.Interface = Interface