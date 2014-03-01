// Generated by CoffeeScript 1.6.3
(function() {
  var Drawer;

  Drawer = (function() {
    function Drawer() {}

    Drawer.prototype.angleMod = Math.PI / 180;

    Drawer.prototype.rectangle = function(context, type, angle, center, width, height) {
      context.save();
      context.translate(center.x, center.y);
      context.rotate(angle * this.angleMod);
      context.rect(-width / 2, -height / 2, width, height);
      if (type === "stroke") {
        context.stroke();
      } else {
        context.fill();
      }
      return context.restore();
    };

    Drawer.prototype.polygon = function(context, type, angle, center, sides, radius) {
      var a, i, _i;
      context.save();
      context.translate(center.x, center.y);
      context.rotate((angle - 90) * this.angleMod);
      a = (Math.PI * 2) / sides;
      context.beginPath();
      context.moveTo(radius, 0);
      for (i = _i = 1; 1 <= sides ? _i <= sides : _i >= sides; i = 1 <= sides ? ++_i : --_i) {
        context.lineTo(radius * Math.cos(a * i), radius * Math.sin(a * i));
      }
      context.closePath();
      if (type === "stroke") {
        context.stroke();
      } else {
        context.fill();
      }
      return context.restore();
    };

    Drawer.prototype.image = function(context, img, angle, center, width, height) {
      context.save();
      context.translate(center.x, center.y);
      context.rotate(angle * this.angleMod);
      context.drawImage(img, -width / 2, -height / 2, width, height);
      return context.restore();
    };

    return Drawer;

  })();

  window.drawer = new Drawer;

}).call(this);
