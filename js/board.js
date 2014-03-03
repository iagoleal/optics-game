// Generated by CoffeeScript 1.6.3
(function() {
  var ConcaveMirror, ConvexMirror, Laser, LaserGun, Mirror, PlaneMirror, Turnable, _ref, _ref1, _ref2, _ref3, _ref4,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Turnable = (function() {
    Turnable.prototype.pos = null;

    Turnable.prototype.angle = 0;

    function Turnable(pos, angle) {
      this.pos = pos != null ? pos : {
        x: 0,
        y: 0
      };
      this.angle = angle != null ? angle : 0;
    }

    Turnable.prototype.turn = function(dgr) {
      this.angle += dgr;
      if (this.angle > 360) {
        this.angle -= 360;
      } else if (this.angle < 0) {
        this.angle += 360;
      }
      return this;
    };

    Turnable.prototype.draw = function(context) {
      return drawer.rectangle(context, "fill", this.angle, this.pos, 100, 10);
    };

    return Turnable;

  })();

  Mirror = (function(_super) {
    __extends(Mirror, _super);

    function Mirror() {
      _ref = Mirror.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Mirror.prototype.img = null;

    Mirror.prototype.width = 100;

    Mirror.prototype.draw = function(context) {
      return drawer.rectangle(context, "fill", this.angle, this.pos, this.width, 10);
    };

    return Mirror;

  })(Turnable);

  PlaneMirror = (function(_super) {
    __extends(PlaneMirror, _super);

    function PlaneMirror() {
      _ref1 = PlaneMirror.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    return PlaneMirror;

  })(Mirror);

  ConvexMirror = (function(_super) {
    __extends(ConvexMirror, _super);

    function ConvexMirror() {
      _ref2 = ConvexMirror.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    return ConvexMirror;

  })(Mirror);

  ConcaveMirror = (function(_super) {
    __extends(ConcaveMirror, _super);

    function ConcaveMirror() {
      _ref3 = ConcaveMirror.__super__.constructor.apply(this, arguments);
      return _ref3;
    }

    return ConcaveMirror;

  })(Mirror);

  LaserGun = (function(_super) {
    __extends(LaserGun, _super);

    function LaserGun() {
      _ref4 = LaserGun.__super__.constructor.apply(this, arguments);
      return _ref4;
    }

    LaserGun.prototype.radius = 30;

    LaserGun.prototype.img = null;

    LaserGun.prototype.front = function() {
      return {
        x: this.pos.x + this.radius * Math.cos(this.angle * Math.PI / 180),
        y: this.pos.y + this.radius * Math.sin(this.angle * Math.PI / 180)
      };
    };

    LaserGun.prototype.draw = function(context) {
      return drawer.polygon(context, "fill", this.angle, this.pos, 3, this.radius);
    };

    return LaserGun;

  })(Turnable);

  Laser = (function() {
    Laser.prototype.origin = null;

    Laser.prototype.path = null;

    function Laser(origin) {
      this.origin = origin != null ? origin : {
        x: 0,
        y: 0
      };
      this.path = [];
    }

    Laser.prototype.addPoint = function(p) {
      return this.path.push(p);
    };

    Laser.prototype.end = function(p) {
      return this.path[this.path.length];
    };

    Laser.prototype.clear = function(start) {
      this.path = [];
      if (start) {
        return this.origin = start;
      }
    };

    Laser.prototype.draw = function(context) {
      var p1, p2, _i, _len, _ref5;
      if (this.path.length > 0) {
        p1 = this.origin;
        _ref5 = this.path;
        for (_i = 0, _len = _ref5.length; _i < _len; _i++) {
          p2 = _ref5[_i];
          drawer.line(context, p1, p2, {
            color: 'red',
            width: 5,
            shadow: {
              color: '#a00',
              offsetX: 0,
              offsetY: 0,
              blur: 25
            }
          });
          p1 = p2;
        }
      }
      return drawer.setOptions(context, {
        shadow: {
          blur: 0
        }
      });
    };

    return Laser;

  })();

  window.PlaneMirror = PlaneMirror;

  window.LaserGun = LaserGun;

  window.Laser = Laser;

}).call(this);
