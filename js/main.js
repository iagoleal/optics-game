// Generated by CoffeeScript 1.6.3
(function() {
  var Board, mainLoop;

  Board = (function() {
    Board.prototype.canvas = null;

    Board.prototype.context = null;

    Board.prototype.mirrors = null;

    function Board(cv) {
      this.canvas = document.getElementById(cv);
      this.context = this.canvas.getContext("2d");
      this.mirrors = [];
    }

    Board.prototype.addMirror = function(pos, angle) {
      if (angle == null) {
        angle = 0;
      }
      return this.mirrors.push(new Mirror(pos, angle));
    };

    Board.prototype.draw = function() {
      var m, _i, _len, _ref, _results;
      this.canvas.width = this.canvas.width;
      _ref = this.mirrors;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        m = _ref[_i];
        _results.push(m.draw(this.context));
      }
      return _results;
    };

    Board.prototype.animate = function() {
      var m, _i, _len, _ref,
        _this = this;
      _ref = this.mirrors;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        m = _ref[_i];
        m.turn(1);
      }
      return setTimeout(function() {
        return _this.animate();
      }, 1000 / 1000);
    };

    return Board;

  })();

  window.onload = function() {
    window.board = new Board("board");
    window.board.addMirror({
      x: 100,
      y: 100
    }, 0);
    window.board.animate();
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
