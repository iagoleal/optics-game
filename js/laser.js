var Laser, LaserGun,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

LaserGun = (function(_super) {
  __extends(LaserGun, _super);

  LaserGun.prototype.radius = 30;

  LaserGun.prototype.laser = null;

  LaserGun.prototype.img = null;

  function LaserGun(pos, angle, turnable, img) {
    if (pos == null) {
      pos = {
        x: 0,
        y: 0
      };
    }
    this.angle = angle != null ? angle : 0;
    this.turnable = turnable != null ? turnable : true;
    this.img = img;
    this.position = {
      x: pos.x,
      y: pos.y
    };
    this.laser = new Laser;
  }

  LaserGun.prototype.front = function() {
    return {
      x: this.position.x + this.radius * Math.cos(this.angle),
      y: this.position.y + this.radius * Math.sin(this.angle)
    };
  };

  LaserGun.prototype.shot = function(pos) {
    var dx, dy;
    if (this.turnable) {
      dy = pos.y - this.position.y;
      dx = pos.x - this.position.x;
      this.angle = Math.atan2(dy, dx);
    }
    console.log(this.angle * 180 / Math.PI, dy / dx);
    this.laser.clear(this.position, this.front());
    return this.laser.advance(1);
  };

  LaserGun.prototype.collided = function(p) {
    return Physics.Collision.circle(p, this.position, this.radius);
  };

  LaserGun.prototype.draw = function(context, selected) {
    return drawer.image(context, this.img, this.position.x, this.position.y, this.angle, this.position);
  };

  return LaserGun;

})(Geometry.Turnable);

Laser = (function() {
  Laser.prototype.path = null;

  Laser.prototype.color = null;

  Laser.prototype.velocity = null;

  function Laser(origin) {
    if (origin == null) {
      origin = {
        x: 0,
        y: 0
      };
    }
    this.path = [];
    this.color = {
      r: 255,
      g: 255,
      b: 255
    };
    this.velocity = new Physics.Vector;
    this.velocity.magnitude(1);
    if (origin) {
      this.path.push(origin);
    }
  }

  Laser.prototype.addPoint = function(p) {
    this.path.push(p);
    return this.velocity.angle(this.angle(p));
  };

  Laser.prototype.angle = function(point) {
    var dx, dy, _ref;
    if (point == null) {
      point = -1;
    }
    _ref = this.changeRate(point), dy = _ref[0], dx = _ref[1];
    return Math.atan2(dy, dx);
  };

  Laser.prototype.changeRate = function(point) {
    var dx, dy;
    if (point == null) {
      point = -1;
    }
    if (point < 0) {
      point = this.path.length + point;
    }
    if (point < this.path.length && point > 0) {
      dx = this.path[point].x - this.path[point - 1].x;
      dy = this.path[point].y - this.path[point - 1].y;
      return [dy, dx];
    }
    return [0, 0];
  };

  Laser.prototype.last = function(p) {
    if (p) {
      if (this.path.length > 1) {
        this.path[this.path.length - 1] = p;
      } else {
        this.path[this.path.length] = p;
      }
    }
    return {
      x: this.path[this.path.length - 1].x,
      y: this.path[this.path.length - 1].y
    };
  };

  Laser.prototype.advance = function() {
    this.path[this.path.length - 1].x += this.velocity.magnitude() * Math.cos(this.angle());
    return this.path[this.path.length - 1].y += this.velocity.magnitude() * Math.sin(this.angle());
  };

  Laser.prototype.clear = function() {
    var point, _i, _len, _results;
    this.path = [];
    _results = [];
    for (_i = 0, _len = arguments.length; _i < _len; _i++) {
      point = arguments[_i];
      _results.push(this.path.push(point));
    }
    return _results;
  };

  Laser.prototype.draw = function(context) {
    var color, i, lineWidth, _i, _results;
    if (this.path.length > 1) {
      _results = [];
      for (i = _i = 5; _i >= 0; i = --_i) {
        lineWidth = (i + 1) * 4 - 2;
        color = i === 0 ? '#fff' : "rgba(" + this.color.r + ", " + this.color.g + ", " + this.color.b + ", 0.2)";
        _results.push(drawer.path(context, this.path, {
          color: color,
          width: lineWidth
        }));
      }
      return _results;
    }
  };

  return Laser;

})();

window.LaserGun = LaserGun;
