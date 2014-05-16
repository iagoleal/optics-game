var Drawer;

Drawer = (function() {
  function Drawer() {}

  Drawer.prototype.angleMod = 1;

  Drawer.prototype.setOptions = function(context, options) {
    var index, j, option, shadowOption, _results;
    _results = [];
    for (index in options) {
      option = options[index];
      switch (index) {
        case "color":
          context.strokeStyle = option;
          _results.push(context.fillStyle = option);
          break;
        case "width":
          _results.push(context.lineWidth = option);
          break;
        case "join":
          _results.push(context.lineJoin = option);
          break;
        case "shadow":
          _results.push((function() {
            var _results1;
            _results1 = [];
            for (j in option) {
              shadowOption = option[j];
              if (option) {
                switch (j) {
                  case "blur":
                    _results1.push(context.shadowBlur = shadowOption);
                    break;
                  case "color":
                    _results1.push(context.shadowColor = shadowOption);
                    break;
                  case "offsetX":
                    _results1.push(context.shadowOffsetX = shadowOption);
                    break;
                  case "offsetY":
                    _results1.push(context.shadowOffsetY = shadowOption);
                    break;
                  default:
                    _results1.push(void 0);
                }
              }
            }
            return _results1;
          })());
          break;
        default:
          _results.push(void 0);
      }
    }
    return _results;
  };

  Drawer.prototype.arc = function(context, type, center, start, end, radius, options) {
    if (options == null) {
      options = {};
    }
    context.save();
    this.setOptions(context, options);
    context.beginPath();
    context.arc(center.x, center.y, radius, start * this.angleMod, end * this.angleMod);
    if (type === "stroke") {
      context.stroke();
    } else {
      context.fill();
    }
    return context.restore();
  };

  Drawer.prototype.line = function(context, start, end, options) {
    if (options == null) {
      options = {};
    }
    context.save();
    this.setOptions(context, options);
    context.beginPath();
    context.moveTo(start.x, start.y);
    context.lineTo(end.x, end.y);
    context.closePath();
    context.stroke();
    return context.restore();
  };

  Drawer.prototype.distance = function(context, angle, start, distance, options) {
    if (options == null) {
      options = {};
    }
    context.save();
    this.setOptions(context, options);
    context.translate(start.x, start.y);
    context.rotate(angle * this.angleMod);
    context.beginPath();
    context.moveTo(0, 0);
    context.lineTo(0, distance);
    context.closePath();
    context.stroke();
    return context.restore();
  };

  Drawer.prototype.path = function(context, points, options) {
    var p, _i, _len, _ref;
    if (options == null) {
      options = {};
    }
    context.save();
    this.setOptions(context, options);
    context.beginPath();
    context.moveTo(points[0].x, points[0].y);
    _ref = points.slice(1);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      p = _ref[_i];
      context.lineTo(p.x, p.y);
    }
    context.stroke();
    context.closePath();
    return context.restore();
  };

  Drawer.prototype.rectangle = function(context, type, angle, center, width, height, options) {
    if (options == null) {
      options = {};
    }
    context.save();
    this.setOptions(context, options);
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

  Drawer.prototype.polygon = function(context, type, angle, center, sides, radius, options) {
    var a, i, _i;
    if (options == null) {
      options = {};
    }
    context.save();
    this.setOptions(context, options);
    context.translate(center.x, center.y);
    context.rotate(angle * this.angleMod);
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

  Drawer.prototype.image = function(context, img, x, y, angle, center, options) {
    if (options == null) {
      options = {};
    }
    context.save();
    this.setOptions(context, options);
    context.translate(center.x, center.y);
    context.rotate(angle * this.angleMod);
    context.drawImage(img, x, y);
    return context.restore();
  };

  return Drawer;

})();

window.drawer = new Drawer;
