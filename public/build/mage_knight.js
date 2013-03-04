(function() {
  var MageKnight, Maps;

  Maps = new Lawnchair(function() {});

  MageKnight = {
    newMap: function() {
      var mesh, tileStack;
      tileStack = MageKnight.Util.promptForTileStack();
      mesh = new MageKnight.TerrainMesh({
        tileStack: tileStack
      });
      mesh.addTileGroup(new MageKnight.HexCoordinate([]), MageKnight.TileStack.getStartGroup());
      return this.updateMesh(mesh);
    },
    save: function() {
      if (this.terrainMesh == null) {
        throw "No map to save?";
      }
      return Maps.save({
        key: 'map',
        data: this.terrainMesh.toObject()
      });
    },
    load: function() {
      var _this = this;
      return Maps.get('map', function(map) {
        var newMesh;
        if (map != null) {
          try {
            newMesh = MageKnight.TerrainMesh.fromObject(map.data);
            return _this.updateMesh(newMesh);
          } catch (e) {
            console.log("failed to load the map, starting a new one");
            return _this.newMap();
          }
        } else {
          return _this.newMap();
        }
      });
    },
    getStage: function() {
      var _ref;
      return (_ref = this.stage) != null ? _ref : this.stage = (function() {
        var stage;
        stage = new createjs.Stage("demo");
        stage.enableMouseOver();
        createjs.Ticker.useRAF = true;
        createjs.Ticker.setFPS(15);
        createjs.Ticker.addEventListener("tick", function() {
          return stage.update();
        });
        return stage;
      })();
    },
    updateMesh: function(mesh) {
      this.clearMesh();
      return this.setMesh(mesh);
    },
    clearMesh: function() {
      this.terrainMesh = null;
      return this.getStage().removeAllChildren();
    },
    setMesh: function(mesh) {
      var camera, cameraView, cards, cloud, cloudTicker, clouds, controlPanel, getRandomCloud, i, newMeshButton, stage, _i, _len,
        _this = this;
      this.terrainMesh = mesh;
      this.terrainMesh.addObserver(function() {
        return _this.save();
      });
      this.terrainMeshView = new MageKnight.TerrainMeshView(mesh);
      getRandomCloud = function() {
        var cloud, cloudFile, cloudNum, totalSpeed;
        cloudNum = Math.ceil(Math.random() * 6);
        cloudFile = "" + MageKnight.Loader.filePath + "clouds/cloud" + cloudNum + ".png";
        cloud = new createjs.Bitmap(cloudFile);
        cloud.x = Math.random() * 640 - 220;
        cloud.y = Math.random() * 480;
        cloud.scaleX = cloud.scaleY = .33 + Math.random() / 4;
        cloud.alpha = .33 + Math.random() / 4;
        cloud.rotation = 315;
        totalSpeed = .75 + Math.random();
        cloud._speedX = totalSpeed / 2;
        cloud._speedY = -totalSpeed / 4;
        return cloud;
      };
      clouds = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 1; _i <= 10; i = ++_i) {
          _results.push(getRandomCloud());
        }
        return _results;
      })();
      cloudTicker = function() {
        var cloud, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = clouds.length; _i < _len; _i++) {
          cloud = clouds[_i];
          _results.push((function(cloud) {
            if (cloud.x > 860) {
              cloud.x = -220;
            }
            if (cloud.y < -140) {
              cloud.y = 620;
            }
            cloud.x += cloud._speedX;
            return cloud.y += cloud._speedY;
          })(cloud));
        }
        return _results;
      };
      setInterval(function() {
        return cloudTicker();
      }, 50);
      camera = new MageKnight.Camera(this.terrainMeshView);
      cameraView = new MageKnight.CameraView(camera);
      newMeshButton = new MageKnight.ImageButton({
        normal: "new",
        action: function() {
          if (confirm("Are you sure?")) {
            return _this.newMap();
          }
        }
      });
      controlPanel = new MageKnight.ControlPanelView(cameraView, newMeshButton);
      cards = new createjs.Bitmap("" + MageKnight.Loader.filePath + "interface/reference_cards/city.png");
      cards.scaleX = 2.5;
      cards.scaleY = 2.5;
      stage = this.getStage();
      stage.addChild(this.terrainMeshView);
      for (_i = 0, _len = clouds.length; _i < _len; _i++) {
        cloud = clouds[_i];
        stage.addChild(cloud);
      }
      return stage.addChild(controlPanel);
    },
    bootstrap: function() {
      var _ref,
        _this = this;
      return (_ref = this.terrainMesh) != null ? _ref : this.terrainMesh = (function() {
        var terrainMesh;
        terrainMesh = new MageKnight.TerrainMesh();
        _this.setMesh(terrainMesh);
        return terrainMesh;
      })();
    },
    toggleMove: function() {
      MageKnight.ViewSettings.showMoveScore = !MageKnight.ViewSettings.showMoveScore;
      return this.terrainMeshView.updateDisplayList();
    }
  };

  MageKnight.ViewSettings = {
    showMoveScore: false
  };

  window.MageKnight = MageKnight;

}).call(this);

(function() {
  var Button, ImageButton,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Button = (function(_super) {

    __extends(Button, _super);

    function Button(text, trigger) {
      var background, label, outline, overBackground,
        _this = this;
      Button.__super__.constructor.call(this);
      background = new createjs.Shape();
      background.graphics.beginFill("666").drawCircle(10, 10, 10);
      this.addChild(background);
      overBackground = new createjs.Shape();
      overBackground.graphics.beginFill("888").drawCircle(10, 10, 10);
      outline = new createjs.Shape();
      outline.graphics.beginStroke("333").drawCircle(10, 10, 10);
      this.addChild(outline);
      label = new createjs.Text(text, "20px Arial bold");
      label.x = 3;
      label.y = -1;
      this.addChild(label);
      this.addEventListener("click", trigger);
      this.addEventListener("mouseover", function() {
        _this.removeChild(background);
        return _this.addChildAt(overBackground, 0);
      });
      this.addEventListener("mouseout", function() {
        _this.removeChild(overBackground);
        return _this.addChildAt(background, 0);
      });
    }

    return Button;

  })(createjs.Container);

  ImageButton = (function(_super) {

    __extends(ImageButton, _super);

    function ImageButton(opts) {
      var normalFile, normalImage, overFile, overImage,
        _this = this;
      if (opts == null) {
        opts = {};
      }
      ImageButton.__super__.constructor.call(this);
      normalFile = "" + MageKnight.Loader.filePath + "interface/" + opts.normal + ".png";
      normalImage = new createjs.Bitmap(normalFile);
      this.addChild(normalImage);
      this.addEventListener("click", opts.action);
      if (opts.noMouseOver == null) {
        overFile = "" + MageKnight.Loader.filePath + "interface/" + opts.normal + "_over.png";
        overImage = new createjs.Bitmap(overFile);
        this.addEventListener("mouseover", function() {
          _this.removeChild(normalImage);
          return _this.addChild(overImage);
        });
        this.addEventListener("mouseout", function() {
          _this.removeChild(overImage);
          return _this.addChild(normalImage);
        });
      }
    }

    return ImageButton;

  })(createjs.Container);

  MageKnight.Button = Button;

  MageKnight.ImageButton = ImageButton;

}).call(this);

(function() {
  var Camera,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Camera = (function() {

    function Camera(view) {
      this.view = view;
      this.zoomOut = __bind(this.zoomOut, this);

      this.zoomIn = __bind(this.zoomIn, this);

      this.down = __bind(this.down, this);

      this.up = __bind(this.up, this);

      this.right = __bind(this.right, this);

      this.left = __bind(this.left, this);

    }

    Camera.prototype.left = function() {
      return this.view.x += 50;
    };

    Camera.prototype.right = function() {
      return this.view.x -= 50;
    };

    Camera.prototype.up = function() {
      return this.view.y += 50;
    };

    Camera.prototype.down = function() {
      return this.view.y -= 50;
    };

    Camera.prototype.zoomIn = function() {
      return this.view.scaleX = this.view.scaleY *= 1.1;
    };

    Camera.prototype.zoomOut = function() {
      return this.view.scaleX = this.view.scaleY *= 0.9;
    };

    return Camera;

  })();

  MageKnight.Camera = Camera;

}).call(this);

(function() {
  var CameraView,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  CameraView = (function(_super) {

    __extends(CameraView, _super);

    function CameraView(camera) {
      var down, left, right, up, zoomIn, zoomOut;
      this.camera = camera;
      CameraView.__super__.constructor.call(this);
      left = new MageKnight.ImageButton({
        normal: "left",
        action: this.camera.left
      });
      left.x = 6;
      left.y = 215;
      right = new MageKnight.ImageButton({
        normal: "right",
        action: this.camera.right
      });
      right.x = 110;
      right.y = 215;
      up = new MageKnight.ImageButton({
        normal: "up",
        action: this.camera.up
      });
      up.x = 55;
      up.y = 165;
      down = new MageKnight.ImageButton({
        normal: "down",
        action: this.camera.down
      });
      down.x = 55;
      down.y = 270;
      zoomIn = new MageKnight.ImageButton({
        normal: "zoomin",
        action: this.camera.zoomIn
      });
      zoomIn.x = 20;
      zoomIn.y = 400;
      zoomOut = new MageKnight.ImageButton({
        normal: "zoomout",
        action: this.camera.zoomOut
      });
      zoomOut.x = 100;
      zoomOut.y = 400;
      this.addChild(left, right, up, down, zoomIn, zoomOut);
    }

    return CameraView;

  })(createjs.Container);

  MageKnight.CameraView = CameraView;

}).call(this);

(function() {
  var ControlPanelView,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ControlPanelView = (function(_super) {

    __extends(ControlPanelView, _super);

    function ControlPanelView(cameraView, newButton) {
      this.cameraView = cameraView;
      ControlPanelView.__super__.constructor.call(this);
      this.scaleX = this.scaleY = 2;
      this.dimensions = {
        x: 884,
        y: 0,
        width: 396,
        height: 480
      };
      this.collapsedCoordinates = {
        x: 1280,
        y: 0
      };
      this.hidden = true;
      this.doLayout();
      this.addBackground();
      this.addHideShowButton();
      this.addMovementOverlay();
      this.addCamera();
      newButton.x = 10;
      newButton.y = 35;
      this.addChild(newButton);
    }

    ControlPanelView.prototype.doLayout = function() {
      if (this.hidden) {
        createjs.Tween.get(this).to({
          alpha: .5
        }, 800);
        createjs.Tween.get(this).to({
          x: this.collapsedCoordinates.x
        }, 1000, createjs.Ease.quintOut);
        return createjs.Tween.get(this).to({
          y: this.collapsedCoordinates.y
        }, 1000, createjs.Ease.quintOut);
      } else {
        createjs.Tween.get(this).to({
          alpha: 1
        }, 800);
        createjs.Tween.get(this).to({
          x: this.dimensions.x
        }, 1000, createjs.Ease.quintOut);
        return createjs.Tween.get(this).to({
          y: this.dimensions.y
        }, 1000, createjs.Ease.quintOut);
      }
    };

    ControlPanelView.prototype.addBackground = function() {
      var background;
      background = new createjs.Bitmap("" + MageKnight.Loader.filePath + "interface/background.png");
      return this.addChild(background);
    };

    ControlPanelView.prototype.addMovementOverlay = function() {
      var moveButton,
        _this = this;
      moveButton = new MageKnight.ImageButton({
        normal: "movement",
        action: function() {
          return MageKnight.toggleMove();
        }
      });
      moveButton.x = 10;
      moveButton.y = 100;
      return this.addChild(moveButton);
    };

    ControlPanelView.prototype.addHideShowButton = function() {
      var hsButton,
        _this = this;
      hsButton = new MageKnight.ImageButton({
        normal: "lefttab",
        noMouseOver: true,
        action: function() {
          _this.hidden = !_this.hidden;
          return _this.doLayout();
        }
      });
      hsButton.x = -30;
      return this.addChild(hsButton);
    };

    ControlPanelView.prototype.addCamera = function() {
      this.cameraView.x = 20;
      return this.addChild(this.cameraView);
    };

    return ControlPanelView;

  })(createjs.Container);

  MageKnight.ControlPanelView = ControlPanelView;

}).call(this);

(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  MageKnight.Error = (function(_super) {

    __extends(Error, _super);

    function Error(args) {
      Error.__super__.constructor.call(this, args);
    }

    return Error;

  })(Error);

}).call(this);

(function() {
  var HexCoordinate, ValidationError,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ValidationError = (function(_super) {

    __extends(ValidationError, _super);

    function ValidationError() {
      return ValidationError.__super__.constructor.apply(this, arguments);
    }

    return ValidationError;

  })(MageKnight.Error);

  HexCoordinate = (function() {

    function HexCoordinate(array) {
      this.array = HexCoordinate.validate(array);
    }

    HexCoordinate.prototype.toString = function() {
      return "Hexordinate[" + (this.array.join()) + "]";
    };

    HexCoordinate.prototype.isOrigin = function() {
      return this.array.length === 0;
    };

    HexCoordinate.prototype.add = function(hexordinate) {
      var ary;
      ary = this.array.concat(hexordinate.array);
      return new HexCoordinate(ary);
    };

    HexCoordinate.prototype.getAdjacencies = function() {
      return [new HexCoordinate(this.array.concat(0)), new HexCoordinate(this.array.concat(1)), new HexCoordinate(this.array.concat(2)), new HexCoordinate(this.array.concat(3)), new HexCoordinate(this.array.concat(4)), new HexCoordinate(this.array.concat(5))];
    };

    HexCoordinate.prototype.getGroupAdjacencies = function() {
      return [new HexCoordinate(this.array.concat([0, 0, 1])), new HexCoordinate(this.array.concat([1, 1, 2])), new HexCoordinate(this.array.concat([2, 2, 3])), new HexCoordinate(this.array.concat([3, 3, 4])), new HexCoordinate(this.array.concat([4, 4, 5])), new HexCoordinate(this.array.concat([5, 5, 0]))];
    };

    return HexCoordinate;

  })();

  HexCoordinate.validate = function(array) {
    var answer, coordinate, coordinates, count, counts, groups, isValidCoordinate, truncateToMin, _i, _len;
    array = array.array || array;
    coordinates = [0, 1, 2, 3, 4, 5];
    isValidCoordinate = function(el) {
      if (!(coordinates.indexOf(el) > -1)) {
        throw "Invalid index: " + el;
      }
    };
    array.every(isValidCoordinate);
    groups = coordinates.map(function(coordinate) {
      return array.filter(function(el) {
        return el === coordinate;
      });
    });
    counts = groups.map(function(group) {
      return group.length;
    });
    truncateToMin = function(groupsToReduce, groupToAdd) {
      var group, numToTransfer, _i, _len;
      if (groupToAdd == null) {
        groupToAdd = null;
      }
      numToTransfer = Math.min.apply(null, (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = groupsToReduce.length; _i < _len; _i++) {
          group = groupsToReduce[_i];
          _results.push(counts[group]);
        }
        return _results;
      })());
      for (_i = 0, _len = groupsToReduce.length; _i < _len; _i++) {
        group = groupsToReduce[_i];
        counts[group] -= numToTransfer;
      }
      if (groupToAdd != null) {
        return counts[groupToAdd] += numToTransfer;
      }
    };
    truncateToMin([0, 2, 4]);
    truncateToMin([1, 3, 5]);
    truncateToMin([0, 3]);
    truncateToMin([1, 4]);
    truncateToMin([2, 5]);
    truncateToMin([0, 2], 1);
    truncateToMin([1, 3], 2);
    truncateToMin([2, 4], 3);
    truncateToMin([3, 5], 4);
    truncateToMin([4, 0], 5);
    truncateToMin([5, 1], 0);
    answer = [];
    for (coordinate = _i = 0, _len = counts.length; _i < _len; coordinate = ++_i) {
      count = counts[coordinate];
      while ((count -= 1) >= 0) {
        answer.push(coordinate);
      }
    }
    return answer;
  };

  HexCoordinate.ValidationError = ValidationError;

  MageKnight.HexCoordinate = HexCoordinate;

}).call(this);

(function() {
  var Terrain, TerrainType, terrainObjectCache;

  TerrainType = {
    grass: {
      type: "grass",
      moveScore: 2
    },
    forest: {
      type: "forest",
      moveScore: 3,
      moveScoreAtNight: 5
    },
    hill: {
      type: "hill",
      moveScore: 3
    },
    desert: {
      type: "desert",
      moveScore: 5,
      moveScoreAtNight: 3
    },
    wasteland: {
      type: "wasteland",
      moveScore: 4
    },
    swamp: {
      type: "swamp",
      moveScore: 5
    },
    mountain: {
      type: "mountain",
      impassable: "true"
    },
    water: {
      type: "water",
      impassable: "true"
    }
  };

  Terrain = (function() {

    function Terrain(opts) {
      if (opts == null) {
        opts = {};
      }
      this.type = opts['type'] || (function() {
        throw "Terrain requires a type";
      })();
      this.moveScore = opts['moveScore'] || Number.POSITIVE_INFINITY;
      this.moveScoreAtNight = opts['moveScoreAtNight'] || this.moveScore;
      this.impassable = opts['impassable'];
    }

    Terrain.prototype.isImpassable = function() {
      return this.impassable != null;
    };

    return Terrain;

  })();

  terrainObjectCache = {};

  Terrain.find = function(type) {
    var _ref;
    return (_ref = terrainObjectCache[type]) != null ? _ref : terrainObjectCache[type] = (function() {
      if (TerrainType[type] == null) {
        throw "No Terrain of type " + type + " found";
      }
      return new Terrain(TerrainType[type]);
    })();
  };

  MageKnight.Terrain = Terrain;

}).call(this);

(function() {
  var TerrainMesh;

  TerrainMesh = (function() {

    function TerrainMesh(opts) {
      if (opts == null) {
        opts = {};
      }
      this.tiles = {};
      this.groupTiles = [];
      this.observers = [];
      this.tileStack = opts['tileStack'] || new MageKnight.TileStack;
    }

    TerrainMesh.prototype.toObject = function() {
      var index, tile, tileObjects, tileStackObject;
      tileObjects = (function() {
        var _ref, _results;
        _ref = this.tiles;
        _results = [];
        for (index in _ref) {
          tile = _ref[index];
          _results.push(tile.toObject());
        }
        return _results;
      }).call(this);
      tileStackObject = this.tileStack.toObject();
      return {
        tiles: tileObjects,
        tileStack: tileStackObject
      };
    };

    TerrainMesh.prototype.getTileCount = function() {
      return (_(this.tiles)).size();
    };

    TerrainMesh.prototype.revealedTiles = function() {
      var location, tile, _ref, _results;
      _ref = this.tiles;
      _results = [];
      for (location in _ref) {
        tile = _ref[location];
        _results.push(tile);
      }
      return _results;
    };

    TerrainMesh.prototype.revealableLocations = function() {
      var answers, checkAdjacencies, checked,
        _this = this;
      checked = {};
      answers = [];
      checkAdjacencies = function(location) {
        checked[location.array] = true;
        return (_(location.getGroupAdjacencies())).each(function(nearbyLocation) {
          if (checked[nearbyLocation.array] != null) {
            return;
          }
          if (_this.tiles[nearbyLocation.array] != null) {
            return checkAdjacencies(nearbyLocation);
          } else {
            return answers.push(nearbyLocation);
          }
        });
      };
      checkAdjacencies(new MageKnight.HexCoordinate([]));
      return answers;
    };

    TerrainMesh.prototype.addFirstTile = function(tile) {
      var coordinates;
      if (this._originTile != null) {
        throw "Tiles are already started, you can only add tiles at hex coordinates from origin now";
      }
      coordinates = new MageKnight.HexCoordinate([]);
      tile.position = coordinates;
      tile.firstTile = true;
      tile.mesh = this;
      this.tiles[coordinates.array] = tile;
      this._originTile = tile;
      return this.notifyObservers();
    };

    TerrainMesh.prototype.getOriginTile = function() {
      return this._originTile;
    };

    TerrainMesh.prototype.getTileAt = function(hexordinateLiteral) {
      return this.tiles[MageKnight.HexCoordinate.validate(hexordinateLiteral)];
    };

    TerrainMesh.prototype.easyAddTile = function(hexordinateLiteral, tileProperties) {
      var hexordinate, tile;
      if (tileProperties == null) {
        tileProperties = ["grass"];
      }
      hexordinate = new MageKnight.HexCoordinate(hexordinateLiteral);
      tile = MageKnight.Tile.fromArray(tileProperties);
      tile.position = hexordinate;
      return this.addTile(tile);
    };

    TerrainMesh.prototype.addTile = function(tile, opts) {
      var hexordinate, neighborHex, neighbors,
        _this = this;
      if (opts == null) {
        opts = {};
      }
      if (tile.position == null) {
        throw "Tile has no position!";
      }
      if (tile.position.isOrigin()) {
        return this.addFirstTile(tile);
      }
      hexordinate = tile.position;
      if (this.tiles[hexordinate.array] != null) {
        throw "Already a tile at " + hexordinate;
      }
      neighbors = (function() {
        var _i, _len, _ref, _results;
        _ref = hexordinate.getAdjacencies();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          neighborHex = _ref[_i];
          _results.push(neighborHex.array);
        }
        return _results;
      })();
      neighbors = neighbors.filter(function(neighbor) {
        return _this.tiles[neighbor] != null;
      });
      if (neighbors.length === 0) {
        throw new Error("Failure adding a tile at " + hexordinate + ": no neighbors");
      }
      tile.mesh = this;
      this.tiles[hexordinate.array] = tile;
      if (opts['notify'] !== false) {
        return this.notifyObservers();
      }
    };

    TerrainMesh.prototype.addTileGroup = function(centerHexordinate, tileGroup) {
      var tryAdding,
        _this = this;
      (_(tileGroup)).each(function(tile) {
        return tile.position = centerHexordinate.add(tile.position);
      });
      tryAdding = function(group) {
        var retries;
        retries = [];
        (_(group)).each(function(tile) {
          try {
            return _this.addTile(tile, {
              notify: false
            });
          } catch (e) {
            return retries.push(tile);
          }
        });
        if (retries.length === group.length) {
          console.log(retries);
          throw "Can't add these tiles";
        } else if (retries.length > 0) {
          return tryAdding(retries);
        } else {
          _this.groupTiles.push(centerHexordinate);
          return _this.notifyObservers();
        }
      };
      return tryAdding(tileGroup);
    };

    TerrainMesh.prototype.addNextTileGroupAt = function(centerHexordinate) {
      return this.addTileGroup(centerHexordinate, this.nextTileGroup());
    };

    TerrainMesh.prototype.nextTileGroup = function() {
      return this.tileStack.next();
    };

    TerrainMesh.prototype.addObserver = function(observer) {
      this.observers.push(observer);
      return this.notifyObserver(observer);
    };

    TerrainMesh.prototype.notifyObservers = function() {
      var observer, _i, _len, _ref, _results;
      _ref = this.observers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        observer = _ref[_i];
        _results.push(this.notifyObserver(observer));
      }
      return _results;
    };

    TerrainMesh.prototype.notifyObserver = function(observer) {
      return (typeof observer.notify === "function" ? observer.notify() : void 0) || observer();
    };

    return TerrainMesh;

  })();

  TerrainMesh.fromObject = function(object) {
    var mesh, tileObject, tileStack, tiles;
    tiles = (function() {
      var _i, _len, _ref, _results;
      _ref = object.tiles;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tileObject = _ref[_i];
        _results.push(MageKnight.Tile.fromObject(tileObject));
      }
      return _results;
    })();
    tileStack = MageKnight.TileStack.fromObject(object.tileStack);
    mesh = new TerrainMesh({
      tileStack: tileStack
    });
    mesh.addTileGroup(new MageKnight.HexCoordinate([]), tiles);
    return mesh;
  };

  MageKnight.TerrainMesh = TerrainMesh;

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  MageKnight.TerrainMeshView = (function(_super) {

    __extends(TerrainMeshView, _super);

    function TerrainMeshView(model) {
      this.model = model;
      this.updateDisplayList = __bind(this.updateDisplayList, this);

      TerrainMeshView.__super__.constructor.call(this);
      this.x = 140;
      this.y = 400;
      this.rotation = 40;
      this.scaleX = .5;
      this.scaleY = .5;
      this.tileViewFactory = new MageKnight.TileViewCache();
      this.model.addObserver(this.updateDisplayList);
    }

    TerrainMeshView.prototype.updateDisplayList = function() {
      this.clearViews();
      this.addHintViews();
      return this.addTileViews();
    };

    TerrainMeshView.prototype.clearViews = function() {
      return this.removeAllChildren();
    };

    TerrainMeshView.prototype.addTileViews = function() {
      var tile, _i, _len, _ref, _results,
        _this = this;
      _ref = this.model.revealedTiles();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tile = _ref[_i];
        _results.push((function(tile) {
          var tileView;
          tileView = _this.tileViewFactory.findByModel(tile);
          tileView.updateByModel(tile);
          return _this.addChild(tileView);
        })(tile));
      }
      return _results;
    };

    TerrainMeshView.prototype.addHintViews = function() {
      var location, _i, _len, _ref, _results,
        _this = this;
      _ref = this.model.revealableLocations();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        location = _ref[_i];
        _results.push((function(location) {
          var hintView;
          hintView = MageKnight.HintView.fromHexordinate(location);
          hintView.onClick = function() {
            if (confirm("Reveal Tile?")) {
              return _this.model.addNextTileGroupAt(location);
            }
          };
          return _this.addChild(hintView);
        })(location));
      }
      return _results;
    };

    return TerrainMeshView;

  })(createjs.Container);

}).call(this);

(function() {
  var AnimatedTerrainFiles, AnimatedTerrainView, TerrainFiles, TerrainView;

  TerrainFiles = {
    locateFile: function(terrainType) {
      return "" + MageKnight.Loader.filePath + "terrain/" + this[terrainType] + ".png";
    },
    grass: "grass",
    desert: "desert",
    forest: "forest",
    hill: "hill",
    mountain: "mountain",
    water: "water/1",
    swamp: "swamp",
    wasteland: "wasteland"
  };

  AnimatedTerrainFiles = {
    locateFile: function(terrainType) {
      var fileName;
      fileName = this[terrainType];
      if (fileName != null) {
        return "" + MageKnight.Loader.filePath + "terrain/" + fileName + ".png";
      } else {
        return null;
      }
    },
    water: "water_animation"
  };

  TerrainView = {
    create: function(terrain) {
      var animationFile, baseTerrain, terrainFile;
      terrainFile = TerrainFiles.locateFile(terrain.type);
      if (terrainFile == null) {
        throw "No terrain file in dictionary for:" + terrain;
      }
      baseTerrain = new createjs.Bitmap(terrainFile);
      animationFile = AnimatedTerrainFiles.locateFile(terrain.type);
      if (animationFile != null) {
        return AnimatedTerrainView.create(baseTerrain, animationFile);
      } else {
        return baseTerrain;
      }
    }
  };

  AnimatedTerrainView = {
    create: function(baseTerrain, animationFile) {
      var animateCycle, animation, container, play, rewind, spriteSheet;
      container = new createjs.Container;
      spriteSheet = new createjs.SpriteSheet({
        images: [animationFile],
        frames: {
          width: MageKnight.TileView.width,
          height: MageKnight.TileView.height - 8,
          count: 38
        },
        animations: {
          run: [1, 38]
        }
      });
      animation = new createjs.BitmapAnimation(spriteSheet);
      play = function() {
        return animation.play();
      };
      rewind = function() {
        return animation.gotoAndStop("run");
      };
      animateCycle = function() {
        play();
        return setTimeout(function() {
          rewind();
          return setTimeout(function() {
            return animateCycle();
          }, 10000);
        }, 2400);
      };
      animateCycle();
      container.addChild(baseTerrain, animation);
      return container;
    }
  };

  MageKnight.TerrainView = TerrainView;

}).call(this);

(function() {
  var Feature, Tile, TileStack;

  Feature = {
    types: [null, "village", "glade", "monastery", "minegreen", "minered", "mineblue", "minewhite", "orcs", "draconum", "keep", "magetower", "ruins", "dungeon", "tomb", "monsterden", "spawninggrounds", "cityblue", "cityred", "citygreen", "citywhite"],
    next: function(type) {
      var nextIndex;
      nextIndex = this.types.indexOf(type) + 1;
      nextIndex = nextIndex % this.types.length;
      return this.types[nextIndex];
    },
    find: function(name) {
      return name;
    },
    random: function() {
      return this.types[Math.floor(Math.random() * this.types.length)];
    }
  };

  Tile = (function() {

    function Tile(opts) {
      if (opts == null) {
        opts = {};
      }
      this.terrain = (function() {
        var terrain;
        terrain = opts['terrain'];
        if (terrain != null) {
          if (_.isString(terrain)) {
            return MageKnight.Terrain.find(terrain);
          } else {
            return terrain;
          }
        } else {
          return MageKnight.Terrain.find("grass");
        }
      })();
      this.feature = opts['feature'] || null;
      this.position = opts['position'] || new MageKnight.HexCoordinate([]);
      this.firstTile = false;
      this.mesh = null;
      this.observers = [];
    }

    Tile.prototype.isFirstTile = function() {
      return this.firstTile;
    };

    Tile.prototype.toObject = function() {
      return {
        terrain: this.terrain,
        feature: this.feature,
        position: this.position.array
      };
    };

    Tile.prototype.neighborAt = function(location) {
      return this.getNeighbors()[location];
    };

    Tile.prototype.getNeighbors = function() {
      var adjacency, _i, _len, _ref, _results;
      _ref = this.position.getAdjacencies();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        adjacency = _ref[_i];
        _results.push(this.mesh.getTileAt(adjacency.array));
      }
      return _results;
    };

    Tile.prototype.missingNeighborIndices = function() {
      var index, _i, _results;
      _results = [];
      for (index = _i = 0; _i <= 5; index = ++_i) {
        if (!(this.neighborAt(index) != null)) {
          _results.push(index);
        }
      }
      return _results;
    };

    Tile.prototype.addObserver = function(observer) {
      this.observers.push(observer);
      return this.notifyObserver(observer);
    };

    Tile.prototype.notifyObservers = function() {
      var observer, _i, _len, _ref, _results;
      _ref = this.observers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        observer = _ref[_i];
        _results.push(this.notifyObserver(observer));
      }
      return _results;
    };

    Tile.prototype.notifyObserver = function(observer) {
      return (typeof observer.notify === "function" ? observer.notify(this) : void 0) || observer(this);
    };

    return Tile;

  })();

  Tile.fromNames = function(terrainName, featureName) {
    var feature, terrain;
    if (featureName == null) {
      featureName = null;
    }
    terrain = MageKnight.Terrain.find(terrainName);
    feature = Feature.find(featureName);
    return new Tile({
      terrain: terrain,
      feature: feature
    });
  };

  Tile.fromArray = function(orderedProperties) {
    return Tile.fromNames(orderedProperties[0], orderedProperties[1]);
  };

  Tile.fromObject = function(tileObject) {
    tileObject.position = new MageKnight.HexCoordinate(tileObject.position);
    return new Tile(tileObject);
  };

  TileStack = (function() {

    function TileStack(tileGroups) {
      this.tileGroups = tileGroups != null ? tileGroups : [];
    }

    TileStack.prototype.next = function() {
      var tileObject, _i, _len, _ref, _results;
      _ref = this.tileGroups.pop();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tileObject = _ref[_i];
        _results.push(MageKnight.Tile.fromObject(tileObject));
      }
      return _results;
    };

    TileStack.prototype.toObject = function() {
      return this.tileGroups;
    };

    return TileStack;

  })();

  TileStack.Special = {
    portalA: [
      {
        position: [],
        terrain: 'grass',
        feature: 'portal'
      }, {
        position: [0],
        terrain: 'forest'
      }, {
        position: [1],
        terrain: 'grass'
      }, {
        position: [2],
        terrain: 'water'
      }, {
        position: [3],
        terrain: 'water'
      }, {
        position: [4],
        terrain: 'water'
      }, {
        position: [5],
        terrain: 'grass'
      }
    ],
    portalB: [
      {
        position: [],
        terrain: 'grass',
        feature: 'portal'
      }, {
        position: [0],
        terrain: 'forest'
      }, {
        position: [1],
        terrain: 'grass'
      }, {
        position: [2],
        terrain: 'grass'
      }, {
        position: [3],
        terrain: 'water'
      }, {
        position: [4],
        terrain: 'water'
      }, {
        position: [5],
        terrain: 'grass'
      }
    ],
    v: [
      {
        position: [],
        terrain: 'grass',
        feature: 'volkarescamp'
      }, {
        position: [0],
        terrain: 'mountain'
      }, {
        position: [1],
        terrain: 'wasteland',
        feature: 'draconum'
      }, {
        position: [2],
        terrain: 'desert',
        feature: 'village'
      }, {
        position: [3],
        terrain: 'hill'
      }, {
        position: [4],
        terrain: 'water'
      }, {
        position: [5],
        terrain: 'forest',
        feature: 'orcs'
      }
    ]
  };

  TileStack.Grassland = {};

  TileStack.Grassland[1] = [
    {
      position: [],
      terrain: 'forest',
      feature: 'glade'
    }, {
      position: [0],
      terrain: 'water'
    }, {
      position: [1],
      terrain: 'grass',
      featre: 'village'
    }, {
      position: [2],
      terrain: 'grass'
    }, {
      position: [3],
      terrain: 'grass'
    }, {
      position: [4],
      terrain: 'forest'
    }, {
      position: [5],
      terrain: 'forest',
      feature: 'orcs'
    }
  ];

  TileStack.Grassland[2] = [
    {
      position: [],
      terrain: 'hill'
    }, {
      position: [0],
      terrain: 'forest',
      feature: 'glade'
    }, {
      position: [1],
      terrain: 'grass',
      feature: 'village'
    }, {
      position: [2],
      terrain: 'grass'
    }, {
      position: [3],
      terrain: 'hill',
      feature: 'minegreen'
    }, {
      position: [4],
      terrain: 'grass'
    }, {
      position: [5],
      terrain: 'hill',
      feature: 'orcs'
    }
  ];

  TileStack.Grassland[3] = [
    {
      position: [],
      terrain: 'forest'
    }, {
      position: [0],
      terrain: 'hill',
      feature: 'keep'
    }, {
      position: [1],
      terrain: 'hill'
    }, {
      position: [2],
      terrain: 'hill',
      feature: 'minewhite'
    }, {
      position: [3],
      terrain: 'grass',
      feature: 'village'
    }, {
      position: [4],
      terrain: 'grass'
    }, {
      position: [5],
      terrain: 'grass'
    }
  ];

  TileStack.Grassland[4] = [
    {
      position: [],
      terrain: 'desert',
      feature: 'magetower'
    }, {
      position: [0],
      terrain: 'desert'
    }, {
      position: [1],
      terrain: 'mountain'
    }, {
      position: [2],
      terrain: 'grass',
      feature: 'village'
    }, {
      position: [3],
      terrain: 'grass'
    }, {
      position: [4],
      terrain: 'hill',
      feature: 'orcs'
    }, {
      position: [5],
      terrain: 'desert'
    }
  ];

  TileStack.Grassland[5] = [
    {
      position: [],
      terrain: 'water'
    }, {
      position: [0],
      terrain: 'grass',
      feature: 'monastery'
    }, {
      position: [1],
      terrain: 'grass',
      feature: 'orcs'
    }, {
      position: [2],
      terrain: 'hill',
      feature: 'mineblue'
    }, {
      position: [3],
      terrain: 'forest'
    }, {
      position: [4],
      terrain: 'forest',
      feature: 'glade'
    }, {
      position: [5],
      terrain: 'forest'
    }
  ];

  TileStack.Grassland[6] = [
    {
      position: [],
      terrain: 'hill',
      feature: 'minered'
    }, {
      position: [0],
      terrain: 'forest'
    }, {
      position: [1],
      terrain: 'grass'
    }, {
      position: [2],
      terrain: 'forest',
      feature: 'orcs'
    }, {
      position: [3],
      terrain: 'hill'
    }, {
      position: [4],
      terrain: 'hill',
      feature: 'monsterden'
    }, {
      position: [5],
      terrain: 'mountain'
    }
  ];

  TileStack.Grassland[7] = [
    {
      position: [],
      terrain: 'swamp'
    }, {
      position: [0],
      terrain: 'forest',
      feature: 'orcs'
    }, {
      position: [1],
      terrain: 'forest',
      feature: 'glade'
    }, {
      position: [2],
      terrain: 'grass',
      feature: 'dungeon'
    }, {
      position: [3],
      terrain: 'grass'
    }, {
      position: [4],
      terrain: 'grass',
      feature: 'monastery'
    }, {
      position: [5],
      terrain: 'water'
    }
  ];

  TileStack.Grassland[8] = [
    {
      position: [],
      terrain: 'swamp',
      feature: 'orcs'
    }, {
      position: [0],
      terrain: 'forest',
      feature: 'ruins'
    }, {
      position: [1],
      terrain: 'grass'
    }, {
      position: [2],
      terrain: 'swamp',
      feature: 'village'
    }, {
      position: [3],
      terrain: 'swamp'
    }, {
      position: [4],
      terrain: 'forest'
    }, {
      position: [5],
      terrain: 'forest',
      feature: 'glade'
    }
  ];

  TileStack.Grassland[9] = [
    {
      position: [],
      terrain: 'mountain'
    }, {
      position: [0],
      terrain: 'mountain'
    }, {
      position: [1],
      terrain: 'wasteland',
      feature: 'keep'
    }, {
      position: [2],
      terrain: 'grass'
    }, {
      position: [3],
      terrain: 'wasteland',
      feature: 'magetower'
    }, {
      position: [4],
      terrain: 'grass'
    }, {
      position: [5],
      terrain: 'wasteland',
      feature: 'dungeon'
    }
  ];

  TileStack.Grassland[10] = [
    {
      position: [],
      terrain: 'mountain'
    }, {
      position: [0],
      terrain: 'forest'
    }, {
      position: [1],
      terrain: 'grass'
    }, {
      position: [2],
      terrain: 'hill',
      feature: 'ruins'
    }, {
      position: [3],
      terrain: 'hill',
      feature: 'keep'
    }, {
      position: [4],
      terrain: 'hill'
    }, {
      position: [5],
      terrain: 'hill',
      feature: 'monsterden'
    }
  ];

  TileStack.Grassland[11] = [
    {
      position: [],
      terrain: 'grass',
      feature: 'magetower'
    }, {
      position: [0],
      terrain: 'water'
    }, {
      position: [1],
      terrain: 'water'
    }, {
      position: [2],
      terrain: 'hill',
      feature: 'orcs'
    }, {
      position: [3],
      terrain: 'water'
    }, {
      position: [4],
      terrain: 'grass',
      feature: 'ruins'
    }, {
      position: [5],
      terrain: 'hill'
    }
  ];

  TileStack.Grassland[12] = [
    {
      position: [],
      terrain: 'grass',
      feature: 'orcs'
    }, {
      position: [0],
      terrain: 'swamp'
    }, {
      position: [1],
      terrain: 'hill',
      feature: 'monastery'
    }, {
      position: [2],
      terrain: 'mountain'
    }, {
      position: [3],
      terrain: 'grass',
      feature: 'maze'
    }, {
      position: [4],
      terrain: 'hill',
      feature: 'refugeecamp'
    }, {
      position: [5],
      terrain: 'mountain'
    }
  ];

  TileStack.Grassland[13] = [
    {
      position: [],
      terrain: 'forest',
      feature: 'magetower'
    }, {
      position: [0],
      terrain: 'hill',
      feature: 'orcs'
    }, {
      position: [1],
      terrain: 'water'
    }, {
      position: [2],
      terrain: 'forest',
      feature: 'deepminebluegreen'
    }, {
      position: [3],
      terrain: 'grass'
    }, {
      position: [4],
      terrain: 'swamp',
      feature: 'glade'
    }, {
      position: [5],
      terrain: 'forest'
    }
  ];

  TileStack.Grassland[14] = [
    {
      position: [],
      terrain: 'grass'
    }, {
      position: [0],
      terrain: 'grass',
      feature: 'keep'
    }, {
      position: [1],
      terrain: 'wasteland',
      feature: 'maze'
    }, {
      position: [2],
      terrain: 'hill',
      feature: 'village'
    }, {
      position: [3],
      terrain: 'grass'
    }, {
      position: [4],
      terrain: 'desert',
      feature: 'deepmineredwhite'
    }, {
      position: [5],
      terrain: 'desert'
    }
  ];

  TileStack.Core = {};

  TileStack.Core.City = {};

  TileStack.Core.NonCity = {};

  TileStack.Core.NonCity[1] = [
    {
      position: [],
      terrain: 'desert',
      feature: 'monastery'
    }, {
      position: [0],
      terrain: 'desert',
      feature: 'tomb'
    }, {
      position: [1],
      terrain: 'desert'
    }, {
      position: [2],
      terrain: 'desert'
    }, {
      position: [3],
      terrain: 'hill'
    }, {
      position: [4],
      terrain: 'hill',
      feature: 'spawninggrounds'
    }, {
      position: [5],
      terrain: 'mountain'
    }
  ];

  TileStack.Core.NonCity[2] = [
    {
      position: [],
      terrain: 'water'
    }, {
      position: [0],
      terrain: 'swamp',
      feature: 'ruins'
    }, {
      position: [1],
      terrain: 'hill',
      feature: 'minegreen'
    }, {
      position: [2],
      terrain: 'swamp',
      feature: 'draconum'
    }, {
      position: [3],
      terrain: 'swamp',
      feature: 'magetower'
    }, {
      position: [4],
      terrain: 'forest'
    }, {
      position: [5],
      terrain: 'water'
    }
  ];

  TileStack.Core.NonCity[3] = [
    {
      position: [],
      terrain: 'wasteland'
    }, {
      position: [0],
      terrain: 'wasteland',
      feature: 'ruins'
    }, {
      position: [1],
      terrain: 'hill',
      feature: 'magetower'
    }, {
      position: [2],
      terrain: 'wasteland'
    }, {
      position: [3],
      terrain: 'hill',
      feature: 'minewhite'
    }, {
      position: [4],
      terrain: 'wasteland',
      feature: 'tomb'
    }, {
      position: [5],
      terrain: 'mountain'
    }
  ];

  TileStack.Core.NonCity[4] = [
    {
      position: [],
      terrain: 'mountain',
      feature: 'draconum'
    }, {
      position: [0],
      terrain: 'hill'
    }, {
      position: [1],
      terrain: 'wasteland',
      feature: 'keep'
    }, {
      position: [2],
      terrain: 'wasteland'
    }, {
      position: [3],
      terrain: 'wasteland',
      feature: 'ruins'
    }, {
      position: [4],
      terrain: 'wasteland'
    }, {
      position: [5],
      terrain: 'hill',
      feature: 'mineblue'
    }
  ];

  TileStack.Core.City[5] = [
    {
      position: [],
      terrain: 'grass',
      feature: 'citygreen'
    }, {
      position: [0],
      terrain: 'swamp',
      feature: 'village'
    }, {
      position: [1],
      terrain: 'swamp',
      feature: 'orcs'
    }, {
      position: [2],
      terrain: 'swamp'
    }, {
      position: [3],
      terrain: 'forest',
      feature: 'orcs'
    }, {
      position: [4],
      terrain: 'water'
    }, {
      position: [5],
      terrain: 'forest',
      feature: 'glade'
    }
  ];

  TileStack.Core.City[6] = [
    {
      position: [],
      terrain: 'grass',
      feature: 'cityblue'
    }, {
      position: [0],
      terrain: 'grass',
      feature: 'monastery'
    }, {
      position: [1],
      terrain: 'water'
    }, {
      position: [2],
      terrain: 'water'
    }, {
      position: [3],
      terrain: 'hill'
    }, {
      position: [4],
      terrain: 'mountain',
      feature: 'draconum'
    }, {
      position: [5],
      terrain: 'forest'
    }
  ];

  TileStack.Core.City[7] = [
    {
      position: [],
      terrain: 'grass',
      feature: 'citywhite'
    }, {
      position: [0],
      terrain: 'grass'
    }, {
      position: [1],
      terrain: 'forest'
    }, {
      position: [2],
      terrain: 'water',
      feature: 'draconum'
    }, {
      position: [3],
      terrain: 'water'
    }, {
      position: [4],
      terrain: 'wasteland',
      feature: 'keep'
    }, {
      position: [5],
      terrain: 'wasteland',
      feature: 'spawninggrounds'
    }
  ];

  TileStack.Core.City[8] = [
    {
      position: [],
      terrain: 'grass',
      feature: 'cityred'
    }, {
      position: [0],
      terrain: 'hill',
      feature: 'minered'
    }, {
      position: [1],
      terrain: 'desert'
    }, {
      position: [2],
      terrain: 'desert',
      feature: 'draconum'
    }, {
      position: [3],
      terrain: 'wasteland'
    }, {
      position: [4],
      terrain: 'wasteland',
      feature: 'draconum'
    }, {
      position: [5],
      terrain: 'desert',
      feature: 'ruins'
    }
  ];

  TileStack.Core.City['v'] = TileStack.Special['v'];

  TileStack.Core.NonCity[9] = [
    {
      position: [],
      terrain: 'grass',
      feature: 'draconum'
    }, {
      position: [0],
      terrain: 'hill',
      feature: 'magetower'
    }, {
      position: [1],
      terrain: 'mountain'
    }, {
      position: [2],
      terrain: 'desert',
      feature: 'refugeecamp'
    }, {
      position: [3],
      terrain: 'desert'
    }, {
      position: [4],
      terrain: 'wasteland'
    }, {
      position: [5],
      terrain: 'hill',
      feature: 'labyrinth'
    }
  ];

  TileStack.Core.NonCity[10] = [
    {
      position: [],
      terrain: 'swamp'
    }, {
      position: [0],
      terrain: 'water'
    }, {
      position: [1],
      terrain: 'forest',
      feature: 'labyrinth'
    }, {
      position: [2],
      terrain: 'hill',
      feature: 'orcs'
    }, {
      position: [3],
      terrain: 'hill',
      feature: 'orcs'
    }, {
      position: [4],
      terrain: 'forest',
      feature: 'keep'
    }, {
      position: [5],
      terrain: 'swamp',
      feature: 'deepmineredwhitebluegreen'
    }
  ];

  TileStack.fromObject = function(tileStackObject) {
    return new TileStack(tileStackObject);
  };

  TileStack.getStartGroup = function() {
    var tileObject, _i, _len, _ref, _results;
    _ref = TileStack.Special["portalA"];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tileObject = _ref[_i];
      _results.push(new MageKnight.Tile.fromObject(tileObject));
    }
    return _results;
  };

  TileStack.shuffle = function(opts) {
    var city, core, finalStack, grasslands, noncity, prepareDeck;
    if (opts == null) {
      opts = {};
    }
    prepareDeck = function(sourceDeck, numberOfTiles) {
      var index, prepDeck, tile;
      if (numberOfTiles === 0) {
        prepDeck = [];
      } else {
        prepDeck = _.shuffle((function() {
          var _results;
          _results = [];
          for (index in sourceDeck) {
            tile = sourceDeck[index];
            _results.push(tile);
          }
          return _results;
        })());
        if (numberOfTiles != null) {
          prepDeck = prepDeck.slice(prepDeck.length - numberOfTiles);
        }
      }
      return prepDeck;
    };
    grasslands = prepareDeck(TileStack.Grassland, opts['grasslands']);
    noncity = prepareDeck(TileStack.Core.NonCity, opts['coreNonCity']);
    city = prepareDeck(TileStack.Core.City, opts['coreCity']);
    core = _.shuffle(noncity.concat(city));
    finalStack = core.concat(grasslands);
    return TileStack.fromObject(finalStack);
  };

  MageKnight.TileStack = TileStack;

  MageKnight.Tile = Tile;

  MageKnight.Feature = Feature;

}).call(this);

(function() {
  var HintView, Loader, TileView, TileViewCache;

  Loader = {
    filePath: ""
  };

  TileView = {
    width: 150,
    height: 196,
    parityChart: {
      0: [1, -1],
      1: [2, 0],
      2: [1, 1],
      3: [-1, 1],
      4: [-2, 0],
      5: [-1, -1]
    },
    featureFileMap: {
      portal: "portal",
      village: "village",
      monastery: "monastery",
      glade: "glade",
      minered: "crystalmine_red",
      mineblue: "crystalmine_blue",
      minegreen: "crystalmine_green",
      minewhite: "crystalmine_white",
      orcs: "orcs",
      draconum: "draconom",
      keep: "keep",
      magetower: "magetower",
      ruins: "ruins",
      dungeon: "dungeon",
      tomb: "tomb",
      monsterden: "monsterden",
      spawninggrounds: "spawning1",
      cityred: "city_red",
      cityblue: "city_blue",
      citygreen: "city_green",
      citywhite: "city_white",
      deepmineredwhite: "redwhitedeepmine",
      deepminebluegreen: "greenbluedeepmine",
      deepmineredwhitebluegreen: "4waydeepmine",
      maze: "maze",
      labyrinth: "labyrinth",
      refugeecamp: "camp",
      volkarescamp: "generalcamp"
    },
    getFeatureView: function(feature) {
      var featureView, terrainView;
      if (this.featureFileMap[feature] != null) {
        featureView = new createjs.Bitmap("" + Loader.filePath + "feature/" + this.featureFileMap[feature] + ".png");
      } else {
        console.log("missing " + feature + " file");
        terrainView = new createjs.Shape();
        terrainView.graphics.beginFill("red").drawCircle(0, 0, 90);
      }
      return featureView;
    },
    getMoveScoreOverlay: function(terrain) {
      var moveScoreText;
      if (!terrain.impassable) {
        moveScoreText = new createjs.Text(terrain.moveScore, "150px Roboto");
        moveScoreText.alpha = .5;
        moveScoreText.x = 30;
      }
      return moveScoreText;
    },
    fromModel: function(model) {
      var container, currentFeatureView, currentMoveScoreOverlay, currentTerrainView, _ref,
        _this = this;
      container = new createjs.Container();
      _ref = this.transformByParity([0, 0], model.position), container.x = _ref[0], container.y = _ref[1];
      currentTerrainView = null;
      currentFeatureView = null;
      currentMoveScoreOverlay = null;
      container.updateByModel = function(model) {
        var newFeatureView, newTerrainView;
        newTerrainView = MageKnight.TerrainView.create(model.terrain);
        if (model.feature != null) {
          newFeatureView = _this.getFeatureView(model.feature);
        }
        if (currentTerrainView != null) {
          container.removeChild(currentTerrainView);
        }
        container.addChild(newTerrainView);
        currentTerrainView = newTerrainView;
        if (currentFeatureView != null) {
          container.removeChild(currentFeatureView);
        }
        container.addChild(newFeatureView);
        currentFeatureView = newFeatureView;
        if (MageKnight.ViewSettings.showMoveScore) {
          currentMoveScoreOverlay = _this.getMoveScoreOverlay(model.terrain);
          return container.addChild(currentMoveScoreOverlay);
        } else {
          if (currentMoveScoreOverlay != null) {
            return container.removeChild(currentMoveScoreOverlay);
          }
        }
      };
      model.addObserver(function() {
        return container.updateByModel(model);
      });
      container.alpha = 0;
      setTimeout(function() {
        createjs.Tween.get(container).to({
          alpha: 1
        }, 5000, createjs.Ease.quintOut);
        return createjs.Tween.get(container).to({
          rotation: 360
        }, 3000, createjs.Ease.quintOut);
      });
      return container;
    },
    getNightFilter: function() {
      var brightness, colorMatrix, colorMatrixFilter, contrast, hue, saturation;
      if (!(createjs.ColorMatrix && createjs.ColorMatrixFilter)) {
        throw "You must have the external Filters included!";
      }
      brightness = -5;
      contrast = 0;
      saturation = -35;
      hue = -82;
      colorMatrix = new createjs.ColorMatrix(brightness, contrast, saturation, hue);
      return colorMatrixFilter = new createjs.ColorMatrixFilter(colorMatrix);
    },
    transformByParity: function(coordinate, hexordinates) {
      var hexordinate, transformedX, transformedY, _fn, _i, _len, _ref,
        _this = this;
      transformedX = coordinate[0];
      transformedY = coordinate[1];
      _ref = hexordinates.array;
      _fn = function(hexordinate) {
        var parity;
        parity = _this.parityChart[hexordinate];
        if (parity == null) {
          throw "What neighbor is this? " + direction;
        }
        transformedX += _this.width * parity[0] / 2;
        return transformedY += 2 * _this.height * parity[1] / 3;
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hexordinate = _ref[_i];
        _fn(hexordinate);
      }
      return [transformedX, transformedY];
    }
  };

  HintView = {
    fromHexordinate: function(hexordinate) {
      var centerPoint, container, hintOver, hintView, _ref, _ref1;
      hintView = new createjs.Shape();
      centerPoint = [TileView.width / 2, TileView.height / 2];
      hintView.graphics.beginFill("#222").drawCircle(0, 0, 220);
      hintView.alpha = .5;
      _ref = TileView.transformByParity(centerPoint, hexordinate), hintView.x = _ref[0], hintView.y = _ref[1];
      hintOver = new createjs.Shape();
      hintOver.graphics.beginFill("yellow").drawCircle(0, 0, 50);
      hintOver.alpha = .25;
      _ref1 = TileView.transformByParity(centerPoint, hexordinate), hintOver.x = _ref1[0], hintOver.y = _ref1[1];
      container = new createjs.Container();
      container.addChild(hintView);
      container.onMouseOver = function() {
        return container.addChild(hintOver);
      };
      container.onMouseOut = function() {
        return container.removeChild(hintOver);
      };
      return container;
    }
  };

  TileViewCache = (function() {

    function TileViewCache() {}

    TileViewCache.prototype.findByModel = function(model) {
      var _base, _name, _ref, _ref1;
      if ((_ref = this._tileViews) == null) {
        this._tileViews = {};
      }
      if ((_ref1 = (_base = this._tileViews)[_name = model.position.array]) == null) {
        _base[_name] = TileView.fromModel(model);
      }
      return this._tileViews[model.position.array];
    };

    return TileViewCache;

  })();

  MageKnight.Loader = Loader;

  MageKnight.TileView = TileView;

  MageKnight.HintView = HintView;

  MageKnight.TileViewCache = TileViewCache;

}).call(this);

(function() {

  MageKnight.Util = {
    promptUntilValid: function(text, maxAnswer) {
      var answer, attempt, parsedAttempt;
      answer = null;
      text = text + (" [1.." + maxAnswer + "]");
      while (answer == null) {
        attempt = prompt(text);
        parsedAttempt = parseInt(attempt);
        if (_.isNaN(parsedAttempt)) {
          text = ("Fail: " + attempt + " could not be parsed as a number.\n") + text;
        } else if (parsedAttempt <= 0) {
          text = ("Fail: " + parsedAttempt + " must be greater than zero.\n") + text;
        } else if (parsedAttempt > maxAnswer) {
          answer = maxAnswer;
        } else {
          answer = parsedAttempt;
        }
      }
      return answer;
    },
    promptForTileStack: function() {
      var city, grasslands, nonCity;
      grasslands = this.promptUntilValid("How many Grassland tiles?", _.size(MageKnight.TileStack.Grassland));
      nonCity = this.promptUntilValid("How many Non-City Core tiles?", _.size(MageKnight.TileStack.Core.NonCity));
      city = this.promptUntilValid("How many City Core tiles?", _.size(MageKnight.TileStack.Core.City));
      return MageKnight.TileStack.shuffle({
        grasslands: grasslands,
        coreNonCity: nonCity,
        coreCity: city
      });
    }
  };

}).call(this);
