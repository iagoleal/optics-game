// Generated by CoffeeScript 1.6.3
(function() {
  var Board, mainLoop;

  Board = (function() {
    Board.prototype.canvas = null;

    Board.prototype.context = null;

    Board.prototype.bgContext = null;

    Board.prototype.width = 0;

    Board.prototype.height = 0;

    Board.prototype.gun = null;

    Board.prototype.mirrors = null;

    Board.prototype.stars = null;

    Board.prototype.shoted = false;

    function Board(cv) {
      var bcanvas;
      this.canvas = document.getElementById(cv);
      this.context = this.canvas.getContext("2d");
      bcanvas = document.getElementById('bground');
      this.bgContext = bcanvas.getContext("2d");
      this.width = this.canvas.width;
      this.height = this.canvas.height;
      this.context.fillStyle = 'white';
      this.context.strokeStyle = 'white';
      this.context.lineJoin = "bevel";
      this.bgContext.fillStyle = 'black';
      this.bgContext.fillRect(0, 0, this.width, this.height);
      this.gun = new LaserGun({
        x: this.width / 2,
        y: this.height / 2
      }, 0);
      this.mirrors = [];
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

    Board.prototype.recalculate = function() {
      var a, star, _i, _len, _ref;
      if (this.gun.laser.path.length >= 2) {
        _ref = this.stars;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          star = _ref[_i];
          star.glow = false;
        }
        this.gun.laser.clear(this.gun.position, this.gun.front());
        while (this.collided(this.gun.laser.last()) !== "wall") {
          this.gun.laser.advance(1);
          a = this.collided(this.gun.laser.last());
          if (a && a.type === "Mirror") {
            this.reflect(a);
          }
          if (a && a.type === "Star") {
            a.glow = true;
          }
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
      var mirror, star, _i, _j, _len, _len1, _ref, _ref1;
      if (pos.x <= 0 || pos.x >= this.width || pos.y <= 0 || pos.y >= this.height) {
        return "wall";
      }
      _ref = this.mirrors;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mirror = _ref[_i];
        if (mirror.collided(pos)) {
          return mirror;
        }
      }
      _ref1 = this.stars;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        star = _ref1[_j];
        if (star.collided(pos)) {
          return star;
        }
      }
      return null;
    };

    Board.prototype.addMirror = function(pos, angle) {
      if (angle == null) {
        angle = 0;
      }
      return this.mirrors.push(new PlaneMirror(pos, angle));
    };

    Board.prototype.addStar = function(pos, radius) {
      return this.stars.push(new Star(pos, radius));
    };

    Board.prototype.draw = function() {
      var mirror, star, _i, _j, _len, _len1, _ref, _ref1;
      this.canvas.width = this.canvas.width;
      _ref = this.mirrors;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mirror = _ref[_i];
        mirror.draw(this.context);
      }
      this.gun.laser.draw(this.context);
      _ref1 = this.stars;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        star = _ref1[_j];
        star.draw(this.context);
      }
      return this.gun.draw(this.context);
    };

    Board.prototype.animate = function() {
      var coll, i, m, _i, _len, _ref,
        _this = this;
      coll = this.collided(this.gun.laser.last());
      if (!coll && this.shoted) {
        i = 0;
        while (!this.collided(this.gun.laser.last()) && i < 10) {
          this.gun.laser.advance(1);
          i++;
        }
      } else {
        if (coll && coll.type === "Mirror") {
          this.reflect(coll);
        } else if (coll && coll.type === "Star") {
          coll.glow = true;
          this.gun.laser.advance(coll.radius * 2);
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
      return setTimeout(function() {
        return _this.animate();
      }, 1000 / 1000);
    };

    return Board;

  })();

  window.onload = function() {
    var _this = this;
    window.board = new Board("board");
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
    }, 0);
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
    }, 180);
    window.board.addMirror({
      x: 700,
      y: 300
    }, 90);
    window.board.addMirror({
      x: 100,
      y: 300
    }, 270);
    window.board.addStar({
      x: 200,
      y: 350
    }, 10);
    window.board.animate();
    document.getElementById('board').addEventListener('click', function(e) {
      var pos;
      pos = {
        x: e.pageX - board.canvas.offsetLeft,
        y: e.pageY - board.canvas.offsetTop
      };
      return board.shot(pos);
    });
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
    window.board.draw();
    return requestAnimationFrame(mainLoop);
  };

  window.requestAnimationFrame = (function() {
    return window.requestAnimationFrame || window.webkitrequestAnimationFrame || window.mozrequestAnimationFrame || function(cback) {
      return window.setTimeout(cback, 1000 / 60);
    };
  })();

}).call(this);
