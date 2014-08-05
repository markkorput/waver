// Generated by CoffeeScript 1.6.3
(function() {
  var _ref, _ref1, _ref2,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.Wave = (function(_super) {
    __extends(Wave, _super);

    function Wave() {
      _ref = Wave.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Wave.prototype.defaults = {
      amount: 0
    };

    Wave.prototype.initialize = function() {
      var clr, dx, path, y,
        _this = this;
      if (!(path = this.get('path'))) {
        path = new paper.Path();
        this.set({
          path: path
        });
      }
      if (this.get('amount') < 2) {
        dx = paper.view.viewSize.width;
      } else {
        dx = paper.view.viewSize.width / (this.get('amount') - 1);
      }
      y = paper.view.viewSize.height * 0.5;
      _.each(_.range(this.get('amount')), function(i) {
        var segment;
        segment = path.add(new paper.Point(dx * i, y));
        if (i === 0 || i === _this.get('amount') - 1) {
          segment.fixed = true;
          return segment.linear = true;
        }
      });
      clr = new paper.Color(Math.random(), Math.random(), Math.random());
      path.strokeColor = clr;
      return path.smooth();
    };

    Wave.prototype.pointByX = function(x) {
      return this._existingPointByX(x) || this._createPointByX(x);
    };

    Wave.prototype._existingPointByX = function(x) {
      return _.find(_.map(this.get('path').segments, function(segment) {
        return segment.point;
      }), function(point) {
        return point.x === x;
      });
    };

    Wave.prototype._createPointByX = function(x) {
      var p, path, segment;
      path = this.get('path');
      p = _.find(_.map(path.segments, function(segment) {
        return segment.point;
      }), function(point, idx) {
        var segment;
        if (point.x < x) {
          return null;
        }
        segment = path.insert(idx, new paper.Point(x, 0));
        return segment.point;
      });
      if (p) {
        return p;
      }
      segment = path.add(new paper.Point(x, 0));
      return segment.point;
    };

    Wave.prototype.setPoints = function(points_coordinates) {
      var path,
        _this = this;
      path = this.get('path');
      path.removeSegments();
      _.each(points_coordinates, function(coords) {
        return _this.pointByX(coords[0]).y = coords[1];
      });
      return path.smooth();
    };

    return Wave;

  })(Backbone.Model);

  this.WaveOps = (function(_super) {
    __extends(WaveOps, _super);

    function WaveOps() {
      this._frame = __bind(this._frame, this);
      _ref1 = WaveOps.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    WaveOps.prototype.initialize = function() {
      if (!this.get('target')) {
        this.set({
          target: new Wave()
        });
      }
      return paper.view.on('frame', this._frame);
    };

    WaveOps.prototype.drip = function(pos) {
      var t, that;
      that = this;
      return t = new TWEEN.Tween({
        pathHeight: this.pathHeight
      }).to({
        pathHeight: pos.y
      }, 250).easing(TWEEN.Easing.Exponential.Out).onUpdate(function(a, b, c) {
        return that.pathHeight = this.pathHeight;
      }).start();
    };

    WaveOps.prototype._frame = function(event) {
      var _this = this;
      if ((this.pathHeight || 0) === 0) {
        return;
      }
      this.pathHeight = this.pathHeight * 0.95;
      if (this.pathHeight < 0.5) {
        this.pathHeight = 0;
      }
      return _.each(this.get('target').get('path').segments, function(segment, i) {
        var sinHeight, sinSeed;
        if (segment.fixed) {
          return;
        }
        sinSeed = event.count * 10 + (i + i % 30) * 100;
        sinHeight = Math.sin(sinSeed / 200) * _this.pathHeight;
        return segment.point.y = Math.sin(sinSeed / 100) * sinHeight + paper.view.viewSize.height / 2;
      });
    };

    return WaveOps;

  })(Backbone.Model);

  this.WaveSiner = (function(_super) {
    __extends(WaveSiner, _super);

    function WaveSiner() {
      this._frame = __bind(this._frame, this);
      _ref2 = WaveSiner.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    WaveSiner.prototype.defaults = {
      root: 0,
      waveLength: 80,
      amplitude: 10,
      flatline: 0
    };

    WaveSiner.prototype.initialize = function() {
      if (!this.get('target')) {
        this.set({
          target: new Wave({
            amount: 0
          })
        });
      }
      paper.view.on('frame', this._frame);
      return this.set({
        flatline: paper.view.viewSize.height * 0.5
      });
    };

    WaveSiner.prototype._frame = function(event) {
      var amp, flat, length, root,
        _this = this;
      this.set({
        amplitude: Math.sin(event.count * 0.05) * 100,
        waveLength: 80 + Math.sin(event.count * 0.001) * 30
      });
      root = this.get('root');
      length = this.get('waveLength');
      flat = this.get('flatline');
      amp = this.get('amplitude');
      return this.get('target').setPoints(_.map(_.range(root, paper.view.size.width + length * 0.25, length * 0.25), function(x) {
        return [x, Math.sin(x - root / length * (Math.PI * 2)) * amp + flat];
      }));
    };

    return WaveSiner;

  })(Backbone.Model);

}).call(this);
