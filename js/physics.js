// Generated by CoffeeScript 1.6.3
(function() {
  module('Physics');

  Physics.Vector = (function() {
    Vector.prototype.x = 0;

    Vector.prototype.y = 0;

    function Vector(x, y) {
      this.x = x != null ? x : 0;
      this.y = y != null ? y : 0;
    }

    Vector.prototype.magnitude = function(n) {
      var d;
      d = Geometry.distance({
        x: 0,
        y: 0
      }, {
        x: this.x,
        y: this.y
      });
      if (n) {
        d = n;
        this.x = d * Math.cos(this.angle() * Math.PI / 180);
        this.y = d * Math.sin(this.angle() * Math.PI / 180);
      }
      return d;
    };

    Vector.prototype.angle = function(t) {
      var a;
      a = Math.atan2(this.y, this.x) * 180 / Math.PI;
      if (t) {
        a = t;
        this.x = this.magnitude * Math.cos(a * Math.PI / 180);
        this.y = this.magnitude * Math.sin(a * Math.PI / 180);
      }
      return a;
    };

    return Vector;

  })();

  Physics.Optics = {
    reflec: function() {}
  };

  Physics.Collision = {
    rect: function(point, rectPos, width, height, angle) {
      var c, rx, ry, s;
      if (angle == null) {
        angle = 0;
      }
      c = Math.cos(-angle * Math.PI / 180);
      s = Math.sin(-angle * Math.PI / 180);
      rx = rectPos.x + c * (point.x - rectPos.x) - s * (point.y - rectPos.y);
      ry = rectPos.y + s * (point.x - rectPos.x) + c * (point.y - rectPos.y);
      return rectPos.x - width / 2 <= rx && rectPos.x + width / 2 >= rx && rectPos.y - height / 2 <= ry && rectPos.y + height / 2 >= ry;
    },
    circle: function(point, center, radius) {
      return dist2(center, point) <= radius * radius;
    }
  };

}).call(this);
