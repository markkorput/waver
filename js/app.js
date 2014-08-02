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
      var canvas, path, start;
      canvas = document.getElementById('targetCanvas');
      paper.setup(canvas);
      path = new paper.Path();
      path.strokeColor = 'black';
      start = new paper.Point(100, 100);
      path.moveTo(start);
      path.lineTo(start.add([700, -50]));
      return paper.view.draw();
    };

    App.prototype.update = function() {
      var _this = this;
      if (this.get('paused') === true) {
        return;
      }
      this.trigger('update');
      this.draw();
      return requestAnimationFrame(function() {
        return _this.update();
      });
    };

    App.prototype.draw = function() {};

    return App;

  })(Backbone.Model);

}).call(this);
