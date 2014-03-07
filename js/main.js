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

    Board.prototype.laser = null;

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
      this.bgContext.fillStyle = 'black';
      this.bgContext.fillRect(0, 0, this.width, this.height);
      this.gun = new LaserGun({
        x: this.width / 2,
        y: this.height / 2
      }, 0);
      this.laser = new Laser(this.gun.position);
      this.mirrors = [];
    }

    Board.prototype.shot = function(pos) {
      var ang, dx, dy, m, slope;
      dx = pos.x - this.gun.position.x;
      dy = pos.y - this.gun.position.y;
      slope = dy / dx;
      this.shoted = true;
      this.gun.angle = Math.atan2(dy, dx) * 180 / Math.PI;
      console.log(this.gun.angle, slope);
      this.laser.clear(this.gun.front());
      /*
      		  4 |  1
       		---------
       		  3 |  2
      */

      pos.x = this.gun.front().x;
      pos.y = this.gun.front().y;
      if (!this.collided(pos)) {
        if (dx === 0) {
          pos.x = this.laser.last().x;
          pos.y += dy > 0 ? 1 : -1;
        } else {
          pos.x += dx > 0 ? 1 : -1;
          pos.y += dx > 0 ? dy / dx : -dy / dx;
        }
        this.laser.last(pos);
      }
      m = this.collided(pos);
      if ((m != null) && m.type === "Mirror") {
        return ang = m.reflect(pos, this.gun.angle);
      }
    };

    Board.prototype.collided = function(pos) {
      var m, _i, _len, _ref;
      if (pos.x <= 0 || pos.x >= this.width || pos.y <= 0 || pos.y >= this.height) {
        return true;
      }
      _ref = this.mirrors;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        m = _ref[_i];
        if (m.collided(pos)) {
          return m;
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

    Board.prototype.draw = function() {
      var mirror, _i, _len, _ref;
      this.canvas.width = this.canvas.width;
      _ref = this.mirrors;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mirror = _ref[_i];
        mirror.draw(this.context);
      }
      this.gun.draw(this.context);
      return this.laser.draw(this.context);
    };

    Board.prototype.animate = function() {
      var dx, dy, m, pos, _i, _len, _ref, _ref1,
        _this = this;
      pos = this.laser.last();
      if (!this.collided(pos) && this.shoted) {
        _ref = this.laser.changeRate(), dx = _ref[0], dy = _ref[1];
        if (dx === 0) {
          pos.x = this.laser.last().x;
          pos.y += dy > 0 ? 1 : -1;
        } else {
          pos.x += dx > 0 ? 5 : -5;
          pos.y += dx > 0 ? 5 * dy / dx : -5 * dy / dx;
        }
        this.laser.last(pos);
      }
      _ref1 = this.mirrors;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        m = _ref1[_i];
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
      x: 100,
      y: 100
    }, 0);
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
