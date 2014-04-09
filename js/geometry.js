var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module('Geometry');

Geometry.dist2 = function(p1, p2) {
  return Math.abs(p1.x - p2.x) * Math.abs(p1.x - p2.x) + Math.abs(p1.y - p2.y) * Math.abs(p1.y - p2.y);
};

Geometry.dist = function(p1, p2) {
  return Math.sqrt(dist2(p1, p2));
};

Geometry.Turnable = (function() {
  Turnable.prototype.position = null;

  Turnable.prototype.angle = 0;

  function Turnable(pos, angle) {
    if (pos == null) {
      pos = {
        x: 0,
        y: 0
      };
    }
    this.angle = angle != null ? angle : 0;
    this.position = {
      x: pos.x,
      y: pos.y
    };
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

  Turnable.prototype.collided = function(point) {};

  Turnable.prototype.draw = function(context) {};

  return Turnable;

})();

Geometry.Rectangle = (function(_super) {
  __extends(Rectangle, _super);

  Rectangle.prototype.width = 100;

  Rectangle.prototype.height = 10;

  function Rectangle(pos, angle, width, height) {
    if (pos == null) {
      pos = {
        x: 0,
        y: 0
      };
    }
    this.angle = angle != null ? angle : 0;
    this.width = width != null ? width : 100;
    this.height = height != null ? height : 10;
    Rectangle.__super__.constructor.call(this, pos, angle);
  }

  Rectangle.prototype.collided = function(point) {
    return Physics.Collision.rect(point, this.position, this.width, this.height, this.angle);
  };

  Rectangle.prototype.draw = function(context) {
    return drawer.rectangle(context, "fill", this.angle, this.position, this.width, this.height, {
      color: '#aaa'
    });
  };

  return Rectangle;

})(Geometry.Turnable);