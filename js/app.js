// Generated by CoffeeScript 1.6.3
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.App = (function(_super) {
    __extends(App, _super);

    function App() {
      _ref = App.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    App.prototype.initialize = function() {
      return this.setup();
    };

    App.prototype.setup = function() {
      var canvas, test_func,
        _this = this;
      this.controls = new Controls();
      this.controls.on('toggle-playing', function(val) {
        if (val) {
          return paper.view.play();
        } else {
          paper.view.pause();
          return console.log('paused');
        }
      });
      canvas = document.getElementById('targetCanvas');
      paper.setup(canvas);
      this.waveOps = new WaveOps();
      this.waveOps2 = new WaveOps();
      this.rect = new paper.Rectangle(0, 0, 10, 10);
      this.rect.stroke;
      $('canvas').mousedown(function(e) {
        _this.waveOps.drip(new paper.Point(e.offsetX, e.offsetY));
        return _this.waveOps2.drip(new paper.Point(e.offsetX, e.offsetY * 0.95));
      });
      return;
      test_func = function() {
        var pos;
        pos = new paper.Point(Math.random() * paper.view.viewSize.width, paper.view.viewSize.height * 0.5);
        _this.waveOps.drip(pos, Math.random() * 30);
        return setTimeout(test_func, 1000);
      };
      return setTimeout(test_func, 300);
    };

    return App;

  })(Backbone.Model);

}).call(this);
