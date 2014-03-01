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

    Drawer.prototype.img = function(context, image, angle, center, width, height) {
      width = width || image.width;
      height = height || image.height;
      context.save();
      context.translate(center.x, center.y);
      context.rotate(angle * Math.PI / 180);
      context.drawImage(image, -width / 2, -height / 2, width, height);
      return context.restore();
    };

    return Drawer;

  })();

  window.drawer = new Drawer;

}).call(this);
