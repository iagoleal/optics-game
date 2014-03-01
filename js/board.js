// Generated by CoffeeScript 1.6.3
(function() {
  var Mirror, Object,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Object = (function() {
    Object.prototype.x = 0;

    Object.prototype.y = 0;

    Object.prototype.angle = 0;

    function Object(x, y, angle) {
      this.x = x != null ? x : 0;
      this.y = y != null ? y : 0;
      this.angle = angle != null ? angle : 0;
    }

    Object.prototype.turn = function(dgr) {
      this.angle += dgr;
      if (this.angle > 360) {
        return this.angle -= 360;
      } else if (this.angle < 0) {
        return this.angle += 360;
      }
    };

    Object.prototype.draw = function(context) {
      return drawer.rectangle(context, "fill", this.angle, {
        x: this.x,
        y: this.y
      }, 100, 100);
    };

    return Object;

  })();

  Mirror = (function(_super) {
    __extends(Mirror, _super);

    Mirror.prototype.img = null;

    function Mirror(image, x, y, angle) {
      this.x = x != null ? x : 0;
      this.y = y != null ? y : 0;
      this.angle = angle != null ? angle : 0;
      this.img = new Image;
      this.img.src = image;
    }

    Mirror.prototype.draw = function(context) {
      return drawer.image(context, this.img, this.angle, {
        x: this.x,
        y: this.y
      });
    };

    return Mirror;

  })(Object);

  window.Object = Object;

}).call(this);
