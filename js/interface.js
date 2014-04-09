var Button, Turner;

Button = (function() {
  Button.prototype.position = null;

  Button.prototype.click = null;

  Button.prototype.radius = 10;

  function Button(pos, click) {
    if (pos == null) {
      pos = {
        x: 0,
        y: 0
      };
    }
    this.click = click;
    this.position = {
      x: pos.x,
      y: pos.y
    };
    if (!click) {
      click = (function() {
        return null;
      });
    }
  }

  Button.prototype.collided = function(point) {
    return dist2(this.position, point) <= this.radius * this.radius;
  };

  Button.prototype.draw = function(context) {
    return drawer.arc(context, "fill", this.position, 0, 360, this.radius, {
      color: '#fff'
    });
  };

  return Button;

})();

Turner = (function() {
  Turner.prototype.turnable = null;

  function Turner(turnable) {
    this.turnable = turnable != null ? turnable : {
      x: 0,
      y: 0
    };
  }

  Turner.prototype.draw = function(context) {
    var radius;
    radius = (function() {
      switch (false) {
        case !("radius" in this.turnable):
          return this.turnable.radius;
        case !("width" in this.turnable):
          return this.turnable.width / 2;
      }
    }).call(this);
    console.log(111);
    drawer.arc(context, "fill", this.turnable.position, 0, 360, radius + 15, {
      color: "#fff"
    });
    return drawer.arc(context, "clip", this.turnable.position, 0, 360, radius + 3, {
      color: "rgba(0, 0, 0, 0)"
    });
  };

  return Turner;

})();

window.Turner = Turner;