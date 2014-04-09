var Board, Interface, mainLoop;

Board = (function() {
  Board.prototype.canvas = null;

  Board.prototype.context = null;

  Board.prototype.width = 0;

  Board.prototype.height = 0;

  Board.prototype.gun = null;

  Board.prototype.mirrors = null;

  Board.prototype.obstacles = null;

  Board.prototype.stars = null;

  Board.prototype.shoted = false;

  function Board(cv) {
    this.canvas = document.getElementById(cv);
    this.context = this.canvas.getContext("2d");
    this.width = this.canvas.width;
    this.height = this.canvas.height;
    drawer.setOptions(this.context, {
      color: '#000',
      join: 'round'
    });

    this.gun = new LaserGun({
      x: this.width / 2,
      y: this.height / 2
    }, 0);
    this.mirrors = [];
    this.obstacles = [];
    this.stars = [];
  }

  Board.prototype.shot = function(pos) {
    var dx, dy, star, _i, _len, _ref;
    dx = pos.x - this.gun.position.x;
    dy = pos.y - this.gun.position.y;
    _ref = this.stars;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      star = _ref[_i];
      star.glow = false;
    }
    this.shoted = true;
    this.gun.angle = Math.atan2(dy, dx) * 180 / Math.PI;
    console.log(this.gun.angle, dy / dx);
    this.gun.laser.clear(this.gun.position, this.gun.front());
    return this.gun.laser.advance(1);
  };

  Board.prototype.collisionEffect = function(a) {
    if (a && a.type === "Mirror") {
      this.reflect(a);
    }
    if (a && a.type === "Star") {
      a.glow = true;
      return this.gun.laser.advance(a.radius * 2);
    }
  };

  Board.prototype.recalculate = function() {
    var a, star, _i, _len, _ref;
    if (this.gun.laser.path.length >= 2) {
      _ref = this.stars;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        star = _ref[_i];
        star.glow = false;
      }
      this.gun.laser.clear(this.gun.position, this.gun.front());
      a = this.collided(this.gun.laser.last());
      while (!a || !(a && a.type === "Wall")) {
        this.gun.laser.advance(1);
        this.collisionEffect(this.collided(this.gun.laser.last()));
      }
      return this.gun.laser.path[0] = this.gun.front();
    }
  };

  Board.prototype.reflect = function(mirror) {
    var angle, pos;
    angle = mirror.reflect(this.gun.laser.angle());
    pos = this.gun.laser.last();
    pos.x -= 20 * Math.cos(angle * Math.PI / 180);
    pos.y -= 20 * Math.sin(angle * Math.PI / 180);
    return this.gun.laser.addPoint(pos);
  };

  Board.prototype.collided = function(pos) {
    var mirror, obstacle, star, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
    if (pos.x <= 0 || pos.x >= this.width || pos.y <= 0 || pos.y >= this.height) {
      return {
        type: "Wall"
      };
    }
    _ref = this.obstacles;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      obstacle = _ref[_i];
      if (obstacle.collided(pos)) {
        return obstacle;
      }
    }
    _ref1 = this.mirrors;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      mirror = _ref1[_j];
      if (mirror.collided(pos)) {
        return mirror;
      }
    }
    _ref2 = this.stars;
    for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
      star = _ref2[_k];
      if (star.collided(pos)) {
        return star;
      }
    }
    return null;
  };

  Board.prototype.addMirror = function(pos, angle, width) {
    if (angle == null) {
      angle = 0;
    }
    if (width == null) {
      width = 100;
    }
    return this.mirrors.push(new PlaneMirror(pos, angle, width));
  };

  Board.prototype.addStar = function(pos, radius) {
    return this.stars.push(new Star(pos, radius));
  };

  Board.prototype.addWall = function(pos, angle, width) {
    if (angle == null) {
      angle = 0;
    }
    return this.obstacles.push(new Wall(pos, angle, width));
  };

  Board.prototype.draw = function() {
    var mirror, obstacle, star, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _results;
    this.context.save();
    this.context.setTransform(1, 0, 0, 1, 0, 0);
    this.context.clearRect(0, 0, this.width, this.height);
    this.context.restore();
    this.context.fillRect(0, 0, this.width, this.height);
    _ref = this.mirrors;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      mirror = _ref[_i];
      mirror.draw(this.context);
    }
    _ref1 = this.obstacles;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      obstacle = _ref1[_j];
      obstacle.draw(this.context);
    }
    this.gun.laser.draw(this.context);
    this.gun.draw(this.context);
    _ref2 = this.stars;
    _results = [];
    for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
      star = _ref2[_k];
      _results.push(star.draw(this.context));
    }
    return _results;
  };

  Board.prototype.animate = function() {
    var coll, i, m, _i, _len, _ref;
    coll = this.collided(this.gun.laser.last());
    if (!coll && this.shoted) {
      i = 0;
      while (!coll && i < 10) {
        this.gun.laser.advance(1);
        i++;
        coll = this.collided(this.gun.laser.last());
        this.collisionEffect(coll);
      }
    } else {
      if (coll) {
        this.collisionEffect(coll);
      } else {
        this.shoted = false;
        this.recalculate();
      }
    }
    _ref = this.mirrors;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      m = _ref[_i];
      m.turn(0);
    }
    return setTimeout((function(_this) {
      return function() {
        return _this.animate();
      };
    })(this), 1000 / 1000);
  };

  return Board;

})();

Interface = (function() {
  Interface.prototype.width = 0;

  Interface.prototype.height = 0;

  Interface.prototype.context = null;

  Interface.prototype.turner = null;

  function Interface(cv) {
    var canvas;
    canvas = document.getElementById(cv);
    this.context = canvas.getContext("2d");

    this.width = canvas.width;
    this.height = canvas.height;
  }

  Interface.prototype.draw = function() {
    this.context.clearRect(0, 0, this.width, this.height);
    this.context.fillStyle = "blue";
    this.context.strokeStyle = "blue";
    if (this.turner) {
      return this.turner.draw(this.context);
    }
  };

  return Interface;

})();

window.onload = function() {
  var clickTimer, longPress;
  window.board = new Board("board");
  window.buttons = new Interface("buttons");
  window.board.addMirror({
    x: 600,
    y: 70
  }, 45);
  window.board.addMirror({
    x: 200,
    y: 70
  }, 325);
  window.board.addMirror({
    x: 400,
    y: 70
  }, 90);
  window.board.addMirror({
    x: 200,
    y: 600 - 70
  }, 225);
  window.board.addMirror({
    x: 600,
    y: 600 - 70
  }, 135);
  window.board.addMirror({
    x: 400,
    y: 600 - 70
  }, 0);
  window.board.addMirror({
    x: 700,
    y: 300
  }, 45);
  window.board.addWall({
    x: 100,
    y: 300
  }, 270, 100);
  window.board.addStar({
    x: 200,
    y: 350
  }, 10);
  window.board.animate();
  clickTimer = false;
  longPress = false;
  document.addEventListener('mousedown', (function(_this) {
    return function(e) {
      var pos;
      pos = {
        x: e.pageX - board.canvas.offsetLeft,
        y: e.pageY - board.canvas.offsetTop
      };
      return clickTimer = setTimeout(function() {
        var a;
        longPress = true;
        a = board.collided(pos);
        console.log(a);
        if (a) {
          return buttons.turner = new Turner(a);
        }
      }, 1000);
    };
  })(this));
  document.addEventListener('mouseup', (function(_this) {
    return function(e) {
      var pos;
      pos = {
        x: e.pageX - board.canvas.offsetLeft,
        y: e.pageY - board.canvas.offsetTop
      };
      buttons.turner = null;
      clearTimeout(clickTimer);
      if (!longPress) {
        board.shot(pos);
      }
      return longPress = false;
    };
  })(this));
  return requestAnimationFrame(mainLoop);
};

mainLoop = function() {
  var fps;
  if (typeof mainLoop.lastTime === 'undefined') {
    mainLoop.lastTime = new Date().getTime();
  } else {
    fps = 1000 / (new Date().getTime() - mainLoop.lastTime);
    document.getElementById("fps").innerHTML = fps.toFixed(2) + ' fps';
    mainLoop.lastTime = new Date().getTime();
  }
  board.draw();
  buttons.draw();
  return requestAnimationFrame(mainLoop);
};

window.requestAnimationFrame = (function() {
  return window.requestAnimationFrame || window.webkitrequestAnimationFrame || window.mozrequestAnimationFrame || function(cback) {
    return window.setTimeout(cback, 1000 / 60);
  };
})();