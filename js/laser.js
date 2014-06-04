// Generated by CoffeeScript 1.6.3
(function() {
  var Laser, LaserGun,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  LaserGun = (function(_super) {
    __extends(LaserGun, _super);

    LaserGun.prototype.radius = 30;

    LaserGun.prototype.laser = null;

    LaserGun.prototype.img = null;

    function LaserGun(pos, angle, turnable) {
      if (pos == null) {
        pos = {
          x: 0,
          y: 0
        };
      }
      this.angle = angle != null ? angle : 0;
      this.turnable = turnable != null ? turnable : true;
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
      dy = pos.y - this.position.y;
      dx = pos.x - this.position.x;
      this.angle = Math.atan2(dy, dx);
      console.log(this.angle * 180 / Math.PI, dy / dx);
      this.laser.clear();
      this.laser.addPoint();
      return this.laser.advance(1);
    };

    LaserGun.prototype.collided = function(p) {
      return Physics.Collision.circle(p, this.position, this.radius);
    };

    LaserGun.prototype.draw = function(context, selected) {
      var color;
      color = '#ffffff';
      if (selected) {
        color = '#ff0000';
      }
      return drawer.polygon(context, "stroke", this.angle, this.position, 3, this.radius, {
        width: 1,
        color: color
      });
    };

    return LaserGun;

  })(Geometry.Turnable);

  Laser = (function() {
    Laser.prototype.path = null;

    Laser.prototype.color = null;

    Laser.prototype.velocity = 0;

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
      this.velocity = 1;
    }

    Laser.prototype.addPoint = function(p, angle) {
      return this.path.push(new Physics.Vector(0, angle, p));
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

    Laser.prototype.last = function() {
      if (this.path.length) {
        return this.path[this.path.length - 1].position();
      } else {

      }
    };

    Laser.prototype.advance = function() {
      if (this.path.length) {
        return this.path[this.path.length - 1].magnitude += this.velocity;
      }
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

}).call(this);
