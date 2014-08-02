// Generated by CoffeeScript 1.6.3
(function() {
  var _ref, _ref1,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Wave = (function(_super) {
    __extends(Wave, _super);

    function Wave() {
      _ref = Wave.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Wave.prototype.defaults = {
      amount: 10
    };

    Wave.prototype.initialize = function() {
      var path, segmentWidth, start,
        _this = this;
      if (!(path = this.get('path'))) {
        path = new paper.Path();
        this.set({
          path: path
        });
      }
      path.moveTo(start = new paper.Point(0, paper.view.viewSize.height * 0.5));
      segmentWidth = paper.view.viewSize.width / (this.get('amount') + 1);
      _.each(_.range(this.get('amount')), function(i) {
        return path.lineTo(start.add([segmentWidth * i, Math.sin(Math.PI * 0.5 * i) * 20]));
      });
      path.lineTo(start.add([paper.view.viewSize.width, 0]));
      path.strokeColor = 'white';
      return path.smooth();
    };

    return Wave;

  })(Backbone.Model);

  this.WaveOps = (function(_super) {
    __extends(WaveOps, _super);

    function WaveOps() {
      _ref1 = WaveOps.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    WaveOps.prototype.initialize = function() {
      if (!this.get('target')) {
        return this.set({
          target: new Wave()
        });
      }
    };

    return WaveOps;

  })(Backbone.Model);

}).call(this);