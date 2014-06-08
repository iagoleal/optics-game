class Wall extends Geometry.Rectangle
	type: "Wall"
	turnable: off



class Star
	radius: 10
	position: null
	glow: off
	type: "Star"

	color: "#fff"

	stage: 0
	stageMod: 1

	constructor: (pos={x:0, y:0}, @radius=1) ->
		@position =
			x: pos.x
			y: pos.y
		@stage = ~~(Math.random()*50)

	collided: (point) ->
		Geometry.dist2(@position, point) <= @radius*@radius

	draw: (context) ->
		#Animation
		if @stage > 50 or @stage < 0
			@stageMod *= -1
		@stage += @stageMod

		a = "stroke"
		shadow = {color: @color, offsetX: 0, offsetY: 0, blur: 10}
		if @glow is on
			a = "fill"
			shadow.color = '#aaeeff'
			shadow.offsetX = 0
			shadow.offsetY = 0
			shadow.blur = @stage/2
		drawer.arc context, a, @position, 0, 360, @radius, {color: @color, shadow: shadow }

window.Star = Star
window.Wall = Wall