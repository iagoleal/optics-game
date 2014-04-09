class Wall extends Geometry.Rectangle
	type: "Wall"

class PlaneMirror extends Geometry.Rectangle
	type: "Mirror"
	height: 4


	reflect: (ang) -> 
		mangle = if @angle <= 180 then @angle else (@angle-180)
		mangle -= 90 if mangle in [0, 90, 180, 270]
		return  360 - (ang + 2*mangle)

	draw: (context) ->
		drawer.rectangle context, "stroke", @angle, @position, @width, @height, {color: 'white', shadow: {color:'#fff', offsetX: 0, offsetY: 0, blur: 10}}
		drawer.distance context, (45+@angle), @position, 100, {color: 'white'}

class LaserGun extends Geometry.Turnable
	radius: 30
	laser: null
	img: null

	constructor: (pos={x:0, y:0},@angle=0) ->
		super pos, @angle
		@laser = new Laser @position

	front: () ->
		x: @position.x + @radius*Math.cos(@angle*Math.PI/180)
		y: @position.y + @radius*Math.sin(@angle*Math.PI/180)

	draw: (context) ->
		drawer.polygon(context, "stroke", @angle, @position, 3, @radius, {width: 1, color:'white'})


class Laser
	path: null
	color: null

	constructor: (origin) ->
		@path = []
		@color = 
			r: 255
			g: 255
			b: 255
		@path.push(origin) if origin


	addPoint: (p) ->
		@path.push p

	angle: (point=-1) ->
		[dy, dx] = @changeRate(point)

		return Math.atan2(dy, dx) *180/Math.PI

	changeRate: (point=-1) ->
		point = @path.length + point if point < 0
		if point < @path.length and point > 0
			dx = @path[point].x - @path[point-1].x
			dy = @path[point].y - @path[point-1].y

			return [dy, dx]
		return [0, 0]

	last: (p) -> 
		if p
			if @path.length > 1
				@path[@path.length-1] = p
			else
				@path[@path.length] = p
		x: @path[@path.length-1].x
		y: @path[@path.length-1].y

	advance: (rate=1) ->
		@path[@path.length-1].x += rate*Math.cos(@angle()*Math.PI/180)
		@path[@path.length-1].y += rate*Math.sin(@angle()*Math.PI/180)

	clear: () ->
		@path = []
		@path.push point for point in arguments


	draw: (context) ->
		if @path.length > 1
			for i in [5..0]
				lineWidth = (i+1)*4-2
				color = if i is 0 then '#fff' else "rgba(#{@color.r}, #{@color.g}, #{@color.b}, 0.2)"
				drawer.path context, @path, {color: color, width: lineWidth}
class Star
	radius: 10
	position: null
	glow: off
	type: "Star"

	constructor: (pos={x:0, y:0}, @radius=1) ->
		@position =
			x: pos.x
			y: pos.y

	collided: (point) ->
		Geometry.dist2(@position, point) <= @radius*@radius

	draw: (context) ->
		a = "stroke"
		shadow = {color:'#fff', offsetX: 0, offsetY: 0, blur: 10}
		if @glow is on
			a = "fill"
			shadow.color = '#aaeeff'
			shadow.offsetX = 0
			shadow.offsetY = 0
			shadow.blur = 25
			#drawer.arc context, a, @position, 0, 360, @radius*1.7, {color: 'rgba(250, 250, 250, 0.2'}
		drawer.arc context, a, @position, 0, 360, @radius, {color: '#fff', shadow: shadow }

window.Star = Star
window.PlaneMirror = PlaneMirror
window.LaserGun = LaserGun
window.Wall = Wall