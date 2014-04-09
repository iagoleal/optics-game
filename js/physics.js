module('Physics');

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