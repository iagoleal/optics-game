var Laser, LaserGun, PlaneMirror, Star, Wall,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Wall = (function(_super) {
  __extends(Wall, _super);

  function Wall() {
    return Wall.__super__.constructor.apply(this, arguments);
  }

  Wall.prototype.type = "Wall";

  return Wall;

})(Geometry.Rectangle);

PlaneMirror = (function(_super) {
  __extends(PlaneMirror, _super);

  function PlaneMirror() {
    return PlaneMirror.__super__.constructor.apply(this, arguments);
  }

  PlaneMirror.prototype.type = "Mirror";

  PlaneMirror.prototype.height = 4;

  PlaneMirror.prototype.reflect = function(ang) {
    var mangle;
    mangle = this.angle <= 180 ? this.angle : this.angle - 180;
    if (mangle === 0 || mangle === 90 || mangle === 180 || mangle === 270) {
      mangle -= 90;
    }
    return 360 - (ang + 2 * mangle);
  };

  PlaneMirror.prototype.draw = function(context) {
    drawer.rectangle(context, "stroke", this.angle, this.position, this.width, this.height, {
      color: 'white',
      shadow: {
        color: '#fff',
        offsetX: 0,
        offsetY: 0,
        blur: 10
      }
    });
    return drawer.distance(context, 45 + this.angle, this.position, 100, {
      color: 'white'
    });
  };

  return PlaneMirror;

})(Geometry.Rectangle);

LaserGun = (function(_super) {
  __extends(LaserGun, _super);

  LaserGun.prototype.radius = 30;

  LaserGun.prototype.laser = null;

  LaserGun.prototype.img = null;

  function LaserGun(pos, angle) {
    if (pos == null) {
      pos = {
        x: 0,
        y: 0
      };
    }
    this.angle = angle != null ? angle : 0;
    LaserGun.__super__.constructor.call(this, pos, this.angle);
    this.laser = new Laser(this.position);
  }

  LaserGun.prototype.front = function() {
    return {
      x: this.position.x + this.radius * Math.cos(this.angle * Math.PI / 180),
      y: this.position.y + this.radius * Math.sin(this.angle * Math.PI / 180)
    };
  };

  LaserGun.prototype.draw = function(context) {
    return drawer.polygon(context, "stroke", this.angle, this.position, 3, this.radius, {
      width: 1,
      color: 'white'
    });
  };

  return LaserGun;

})(Geometry.Turnable);

Laser = (function() {
  Laser.prototype.path = null;

  Laser.prototype.color = null;

  function Laser(origin) {
    this.path = [];
    this.color = {
      r: 255,
      g: 255,
      b: 255
    };
    if (origin) {
      this.path.push(origin);
    }
  }

  Laser.prototype.addPoint = function(p) {
    return this.path.push(p);
  };

  Laser.prototype.angle = function(point) {
    var dx, dy, _ref;
    if (point == null) {
      point = -1;
    }
    _ref = this.changeRate(point), dy = _ref[0], dx = _ref[1];
    return Math.atan2(dy, dx) * 180 / Math.PI;
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

  Laser.prototype.advance = function(rate) {
    if (rate == null) {
      rate = 1;
    }
    this.path[this.path.length - 1].x += rate * Math.cos(this.angle() * Math.PI / 180);
    return this.path[this.path.length - 1].y += rate * Math.sin(this.angle() * Math.PI / 180);
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

Star = (function() {
  Star.prototype.radius = 10;

  Star.prototype.position = null;

  Star.prototype.glow = false;

  Star.prototype.type = "Star";

  function Star(pos, radius) {
    if (pos == null) {
      pos = {
        x: 0,
        y: 0
      };
    }
    this.radius = radius != null ? radius : 1;
    this.position = {
      x: pos.x,
      y: pos.y
    };
  }

  Star.prototype.collided = function(point) {
    return Geometry.dist2(this.position, point) <= this.radius * this.radius;
  };

  Star.prototype.draw = function(context) {
    var a, shadow;
    a = "stroke";
    shadow = {
      color: '#fff',
      offsetX: 0,
      offsetY: 0,
      blur: 10
    };
    if (this.glow === true) {
      a = "fill";
      shadow.color = '#aaeeff';
      shadow.offsetX = 0;
      shadow.offsetY = 0;
      shadow.blur = 25;
    }
    return drawer.arc(context, a, this.position, 0, 360, this.radius, {
      color: '#fff',
      shadow: shadow
    });
  };

  return Star;

})();

window.Star = Star;

window.PlaneMirror = PlaneMirror;

window.LaserGun = LaserGun;

window.Wall = Wall;