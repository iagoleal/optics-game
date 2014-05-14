class Board
	canvas: null
	context: null
	
	width: 0
	height: 0

	guns: null
	mirrors: null
	obstacles: null
	stars: null

	selectedGun: null

	shoted: false

	constructor: (cv) ->
		@canvas = document.getElementById(cv)
		@context = @canvas.getContext "2d"

		@width = @canvas.width
		@height = @canvas.height


		drawer.setOptions @context, {color: '#000', join: 'round'}

		@guns = []
		@mirrors = []
		@obstacles = []
		@stars = []


	shot: (pos) ->
		if @selectedGun
			star.glow = off for star in @stars
			@shoted = true
			@selectedGun.shot(pos)


	collisionEffect: (a, gun) ->
		if a and a.type is "Mirror"
			@reflect a, gun
		if a and a.type is "Star"
			a.glow = on
			gun.laser.advance()
		
	reflect: (mirror, gun) ->
		angle = mirror.reflect gun.laser.angle()

		pos = gun.laser.last()
		#slope = Math.abs(Math.tan(angle*Math.PI/180))
		pos.x -= 20*Math.cos(angle)
		pos.y -= 20*Math.sin(angle)
		gun.laser.addPoint pos


	collided: (pos) ->
		if pos.x <= 0 or pos.x >= @width or pos.y <= 0 or pos.y >= @height
			return {type: "Wall"}
		return obstacle for obstacle in @obstacles when obstacle.collided(pos)
		return mirror for mirror in @mirrors when mirror.collided(pos)
		return star for star in @stars when star.collided(pos)
		return gun for gun in @guns when gun.collided(pos)
		return null


	setLevel: (lv) ->
		for index, data of lv
			switch index
				when "width"
					@width = data
				when "height"
					@height = data
				when "mirrors"
					for m in data
						# if m.type is "plane"
						@mirrors.push new Mirror.Plane {x: m.x, y: m.y}, m.angle, m.width, m.turnable
				when "obstacles"
					for m in data
						if m.type is "wall"
							@obstacles.push new Wall {x: m.x, y: m.y}, m.angle, m.width
				when "stars"
					for m in data
						@stars.push new Star {x: m.x, y: m.y}, m.radius
				when "guns"
					for m in data
						@guns.push new LaserGun {x: m.x, y: m.y}, m.angle, m.turnable

	selectGun: (pos) ->
		r = false
		for gun in @guns when gun.collided(pos)
			r = true
			@selectedGun = if @selectedGun is gun then null else gun
		return r



	draw: () ->
		#Clear the canvas
		###
		@context.save()

		@context.setTransform(1, 0, 0, 1, 0, 0)
		@context.clearRect 0, 0, @width, @height

		@context.restore()
		###

		#Draw background

		@context.fillRect 0, 0, @width, @height

		mirror.draw @context for mirror in @mirrors
		obstacle.draw @context for obstacle in @obstacles
		for gun in @guns
			gun.laser.draw @context

			isG = (@selectedGun is gun)
			gun.draw @context, isG

		star.draw @context for star in @stars


	animate: () ->
		# Every time function is executed, the laser advances a little bit
		for gun in @guns
			coll = @collided(gun.laser.last())
			if ! coll and @shoted
				i = 0
				while ! coll and i < 10
					gun.laser.advance()
					i++
					coll = @collided(gun.laser.last())
					@collisionEffect coll, gun
			else # if laser animation is finished, just do the laser maintenance
				if coll
					@collisionEffect coll, gun
				else
					@shoted = false# if @collided(@gun.laser.last()) is "wall"

		#m.turn 0 for m in @mirrors
			
		setTimeout => 
			@animate()
		, 1000/60

window.Board = Board