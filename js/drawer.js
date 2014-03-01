// Generated by CoffeeScript 1.6.3
(function() {
  var Drawer;

  Drawer = (function() {
    function Drawer() {}

    Drawer.prototype.rectangle = function(context, type, angle, center, width, height) {
      context.save();
      context.translate(center.x, center.y);
      context.rotate(angle * Math.PI / 180);
      context.rect(-width / 2, -height / 2, width, height);
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
      context.rotate(angle * Math.PI / 180);
      context.drawImage(img, -width / 2, -height / 2, width, height);
      return context.restore();
    };

    return Drawer;

  })();

  window.drawer = new Drawer;

}).call(this);
