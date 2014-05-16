var Board;

Board = (function() {
  Board.prototype.canvas = null;

  Board.prototype.context = null;

  Board.prototype.width = 0;

  Board.prototype.height = 0;

  Board.prototype.guns = null;

  Board.prototype.mirrors = null;

  Board.prototype.obstacles = null;

  Board.prototype.stars = null;

  Board.prototype.selectedGun = null;

  Board.prototype.shoted = false;

  Board.prototype.images = null;

  function Board(cv) {
    this.canvas = document.getElementById(cv);
    this.context = this.canvas.getContext("2d");
    this.width = this.canvas.width;
    this.height = this.canvas.height;
    drawer.setOptions(this.context, {
      color: '#000',
      join: 'round'
    });
    this.guns = [];
    this.mirrors = [];
    this.obstacles = [];
    this.stars = [];
    this.images = {};
  }

  Board.prototype.shot = function(pos) {
    var star, _i, _len, _ref;
    if (this.selectedGun) {
      _ref = this.stars;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        star = _ref[_i];
        star.glow = false;
      }
      this.shoted = true;
      return this.selectedGun.shot(pos);
    }
  };

  Board.prototype.collisionEffect = function(a, gun) {
    if (a && a.type === "Mirror") {
      this.reflect(a, gun);
    }
    if (a && a.type === "Star") {
      a.glow = true;
      return gun.laser.advance();
    }
  };

  Board.prototype.reflect = function(mirror, gun) {
    var angle, pos;
    angle = mirror.reflect(gun.laser.angle());
    pos = gun.laser.last();
    pos.x -= 20 * Math.cos(angle);
    pos.y -= 20 * Math.sin(angle);
    return gun.laser.addPoint(pos);
  };

  Board.prototype.collided = function(pos) {
    var gun, mirror, obstacle, star, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _ref2, _ref3;
    if (pos.x <= 0 || pos.x >= this.width || pos.y <= 0 || pos.y >= this.height) {
      return {
        type: "Wall"
      };
    }
    _ref = this.obstacles;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      obstacle = _ref[_i];
      if (obstacle.collided(pos)) {
        return obstacle;
      }
    }
    _ref1 = this.mirrors;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      mirror = _ref1[_j];
      if (mirror.collided(pos)) {
        return mirror;
      }
    }
    _ref2 = this.stars;
    for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
      star = _ref2[_k];
      if (star.collided(pos)) {
        return star;
      }
    }
    _ref3 = this.guns;
    for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
      gun = _ref3[_l];
      if (gun.collided(pos)) {
        return gun;
      }
    }
    return null;
  };

  Board.prototype.setLevel = function(lv) {
    var can, counter, i, index, _i, _len, _ref;
    counter = 0;
    can = false;
    _ref = lv.images;
    for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
      i = _ref[index];
      this.images[i.name] = new Image();
      this.images[i.name].onload = (function(_this) {
        return function() {
          counter += 1;
          if (counter === lv.images.length) {
            return can = true;
          }
        };
      })(this);
      this.images[i.name].src = i.src;
    }
    if (can) {
      return this._setLevel(lv);
    }
  };

  Board.prototype._setLevel = function(lv) {
    var data, index, m, _results;
    _results = [];
    for (index in lv) {
      data = lv[index];
      switch (index) {
        case "width":
          _results.push(this.width = data);
          break;
        case "height":
          _results.push(this.height = data);
          break;
        case "mirrors":
          _results.push((function() {
            var _i, _len, _results1;
            _results1 = [];
            for (_i = 0, _len = data.length; _i < _len; _i++) {
              m = data[_i];
              _results1.push(this.mirrors.push(new Mirror.Plane({
                x: m.x,
                y: m.y
              }, m.angle, m.width, m.turnable)));
            }
            return _results1;
          }).call(this));
          break;
        case "obstacles":
          _results.push((function() {
            var _i, _len, _results1;
            _results1 = [];
            for (_i = 0, _len = data.length; _i < _len; _i++) {
              m = data[_i];
              if (m.type === "wall") {
                _results1.push(this.obstacles.push(new Wall({
                  x: m.x,
                  y: m.y
                }, m.angle, m.width)));
              } else {
                _results1.push(void 0);
              }
            }
            return _results1;
          }).call(this));
          break;
        case "stars":
          _results.push((function() {
            var _i, _len, _results1;
            _results1 = [];
            for (_i = 0, _len = data.length; _i < _len; _i++) {
              m = data[_i];
              _results1.push(this.stars.push(new Star({
                x: m.x,
                y: m.y
              }, m.radius)));
            }
            return _results1;
          }).call(this));
          break;
        case "guns":
          _results.push((function() {
            var _i, _len, _results1;
            _results1 = [];
            for (_i = 0, _len = data.length; _i < _len; _i++) {
              m = data[_i];
              _results1.push(this.guns.push(new LaserGun({
                x: m.x,
                y: m.y
              }, m.angle, m.turnable, this.images[m.image])));
            }
            return _results1;
          }).call(this));
          break;
        default:
          _results.push(void 0);
      }
    }
    return _results;
  };

  Board.prototype.selectGun = function(pos) {
    var gun, r, _i, _len, _ref;
    r = false;
    _ref = this.guns;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      gun = _ref[_i];
      if (!(gun.collided(pos))) {
        continue;
      }
      r = true;
      this.selectedGun = this.selectedGun === gun ? null : gun;
    }
    return r;
  };

  Board.prototype.draw = function() {

    /*
        @context.save()
    
        @context.setTransform(1, 0, 0, 1, 0, 0)
        @context.clearRect 0, 0, @width, @height
    
        @context.restore()
     */
    var gun, isG, mirror, obstacle, star, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _ref2, _ref3, _results;
    this.context.fillRect(0, 0, this.width, this.height);
    _ref = this.mirrors;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      mirror = _ref[_i];
      mirror.draw(this.context);
    }
    _ref1 = this.obstacles;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      obstacle = _ref1[_j];
      obstacle.draw(this.context);
    }
    _ref2 = this.guns;
    for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
      gun = _ref2[_k];
      gun.laser.draw(this.context);
      isG = this.selectedGun === gun;
      gun.draw(this.context, isG);
    }
    _ref3 = this.stars;
    _results = [];
    for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
      star = _ref3[_l];
      _results.push(star.draw(this.context));
    }
    return _results;
  };

  Board.prototype.animate = function() {
    var coll, gun, i, _i, _len, _ref;
    _ref = this.guns;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      gun = _ref[_i];
      coll = this.collided(gun.laser.last());
      if (!coll && this.shoted) {
        i = 0;
        while (!coll && i < 10) {
          gun.laser.advance();
          i++;
          coll = this.collided(gun.laser.last());
          this.collisionEffect(coll, gun);
        }
      } else {
        if (coll) {
          this.collisionEffect(coll, gun);
        } else {
          this.shoted = false;
        }
      }
    }
    return setTimeout((function(_this) {
      return function() {
        return _this.animate();
      };
    })(this), 1000 / 60);
  };

  return Board;

})();

window.Board = Board;
