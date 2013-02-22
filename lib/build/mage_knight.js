(function() {
  var MageKnight;

  MageKnight = {
    bootstrap: function() {
      var _ref;
      return (_ref = this.terrainMesh) != null ? _ref : this.terrainMesh = (function() {
        var controlPanel, stage, terrainMesh, terrainMeshView;
        stage = new createjs.Stage("demo");
        stage.enableMouseOver();
        terrainMesh = new MageKnight.TerrainMesh();
        terrainMeshView = new MageKnight.TerrainMeshView(terrainMesh);
        stage.addChild(terrainMeshView);
        controlPanel = new MageKnight.ControlPanelView(terrainMeshView);
        stage.addChild(controlPanel);
        createjs.Ticker.useRAF = true;
        createjs.Ticker.setFPS(5);
        createjs.Ticker.addEventListener("tick", function() {
          return stage.update();
        });
        return terrainMesh;
      })();
    },
    startWithMegaTile: function(tiles) {
      var middleTile, terrainMesh;
      terrainMesh = this.bootstrap();
      middleTile = MageKnight.Tile.fromNames(tiles[1][1][0], tiles[1][1][1]);
      terrainMesh.addFirstTile(middleTile);
      terrainMesh.addTile([0], [tiles[0][1][0], tiles[0][1][1]]);
      terrainMesh.addTile([1], [tiles[1][2][0], tiles[1][2][1]]);
      terrainMesh.addTile([2], [tiles[2][1][0], tiles[2][1][1]]);
      terrainMesh.addTile([3], [tiles[2][0][0], tiles[2][0][1]]);
      terrainMesh.addTile([4], [tiles[1][0][0], tiles[1][0][1]]);
      return terrainMesh.addTile([5], [tiles[0][0][0], tiles[0][0][1]]);
    }
  };

  window.MageKnight = MageKnight;

}).call(this);

(function() {
  var Button, ControlPanelView,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ControlPanelView = (function(_super) {

    __extends(ControlPanelView, _super);

    function ControlPanelView(mapView) {
      ControlPanelView.__super__.constructor.call(this);
      this.dimensions = {
        x: 580,
        y: 0,
        width: 60,
        height: 480
      };
      this.doLayout();
      this.addBackground();
      this.addCameraButtons(mapView);
    }

    ControlPanelView.prototype.doLayout = function() {
      this.x = this.dimensions.x;
      return this.y = this.dimensions.y;
    };

    ControlPanelView.prototype.addBackground = function() {
      var shape;
      shape = new createjs.Shape();
      shape.graphics.beginFill("lightgray").drawRect(0, 0, this.dimensions.width, this.dimensions.height);
      return this.addChild(shape);
    };

    ControlPanelView.prototype.addCameraButtons = function(mapView) {
      var down, left, right, up, zoomIn, zoomOut;
      left = new Button("<", function() {
        return mapView.x -= 50;
      });
      left.x = 0;
      left.y = 40;
      right = new Button(">", function() {
        return mapView.x += 50;
      });
      right.x = 40;
      right.y = 40;
      up = new Button("^", function() {
        return mapView.y -= 50;
      });
      up.x = 20;
      up.y = 25;
      down = new Button("V", function() {
        return mapView.y += 50;
      });
      down.x = 20;
      down.y = 55;
      zoomIn = new Button("+", function() {
        return mapView.scaleX = mapView.scaleY *= 1.1;
      });
      zoomIn.x = 10;
      zoomOut = new Button("-", function() {
        return mapView.scaleX = mapView.scaleY *= .9;
      });
      zoomOut.x = 35;
      return this.addChild(left, right, up, down, zoomIn, zoomOut);
    };

    return ControlPanelView;

  })(createjs.Container);

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

    HexCoordinate.prototype.getAdjacencies = function() {
      return [new HexCoordinate(this.array.concat(0)), new HexCoordinate(this.array.concat(1)), new HexCoordinate(this.array.concat(2)), new HexCoordinate(this.array.concat(3)), new HexCoordinate(this.array.concat(4)), new HexCoordinate(this.array.concat(5))];
    };

    return HexCoordinate;

  })();

  HexCoordinate.validate = function(array) {
    var answer, coordinate, coordinates, count, counts, groups, isValidCoordinate, truncateToMin, _i, _len;
    array = array.array || array;
    coordinates = [0, 1, 2, 3, 4, 5];
    isValidCoordinate = function(el) {
      return coordinates.indexOf(el) > -1;
    };
    if (!array.every(isValidCoordinate)) {
      throw new ValidationError("Invalid index");
    }
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
  var TerrainMesh;

  TerrainMesh = (function() {

    function TerrainMesh() {
      this.tiles = {};
      this.observers = [];
    }

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
      var adjacencies,
        _this = this;
      adjacencies = this.revealedTiles().map(function(tile) {
        return tile.position.getAdjacencies();
      });
      adjacencies = adjacencies.reduce(function(acc, adjs) {
        return acc.concat(adjs);
      }, []);
      return adjacencies = adjacencies.filter(function(adj) {
        return !(_this.tiles[adj.array] != null);
      });
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

    TerrainMesh.prototype.addTile = function(hexordinateLiteral, tileProperties) {
      var hexordinate, neighborHex, neighbors, newTile, _fn, _i, _len, _ref,
        _this = this;
      if (tileProperties == null) {
        tileProperties = ["grass"];
      }
      hexordinate = new MageKnight.HexCoordinate(hexordinateLiteral);
      newTile = MageKnight.Tile.fromArray(tileProperties);
      newTile.position = hexordinate;
      newTile.mesh = this;
      if (this.tiles[hexordinate.array] != null) {
        throw "Already a tile at " + hexordinate;
      }
      neighbors = [];
      _ref = hexordinate.getAdjacencies();
      _fn = function(neighborHex) {
        return neighbors.push(neighborHex.array);
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        neighborHex = _ref[_i];
        _fn(neighborHex);
      }
      neighbors = neighbors.filter(function(neighbor) {
        return _this.tiles[neighbor] != null;
      });
      if (neighbors.length === 0) {
        throw "Failure adding a tile at " + hexordinate + ": no neighbors";
      }
      this.tiles[hexordinate.array] = newTile;
      return this.notifyObservers();
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
      this.x = this.y = 200;
      this.scaleX = this.scaleY = .5;
      this.tileViewFactory = new MageKnight.TileViewCache();
      this.model.addObserver(this.updateDisplayList);
    }

    TerrainMeshView.prototype.updateDisplayList = function() {
      this.clearViews();
      this.addTileViews();
      return this.addHintViews();
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
            return _this.model.addTile(location.array, MageKnight.Tile.generateRandom());
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
  var Feature, Terrain, Tile;

  Terrain = {
    types: ["grass", "forest", "hill", "mountain", "desert", "swamp", "wasteland", "water"],
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

    function Tile(terrain, feature) {
      this.terrain = terrain;
      this.feature = feature != null ? feature : null;
      this.position = [];
      this.neighbors = [];
      this.firstTile = false;
      this.mesh = null;
      this.observers = [];
    }

    Tile.prototype.isFirstTile = function() {
      return this.firstTile;
    };

    Tile.prototype.cycleTerrain = function() {
      this.terrain = Terrain.next(this.terrain);
      return this.notifyObservers();
    };

    Tile.prototype.cycleFeature = function() {
      this.feature = Feature.next(this.feature);
      return this.notifyObservers();
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
    terrain = Terrain.find(terrainName);
    feature = Feature.find(featureName);
    return new Tile(terrain, feature);
  };

  Tile.fromArray = function(orderedProperties) {
    return Tile.fromNames(orderedProperties[0], orderedProperties[1]);
  };

  Tile.generateRandom = function() {
    return [Terrain.random()];
  };

  MageKnight.Tile = Tile;

  MageKnight.Terrain = Terrain;

  MageKnight.Feature = Feature;

}).call(this);

(function() {
  var HintView, TileView, TileViewCache;

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
    terrainFileMap: {
      grass: "grass",
      desert: "desert",
      forest: "forest",
      hill: "hill",
      mountain: "mountain",
      water: "water/1",
      swamp: "swamp",
      wasteland: "wasteland"
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
      citywhite: "city_white"
    },
    getTerrainView: function(terrain) {
      var terrainView;
      if (this.terrainFileMap[terrain] != null) {
        terrainView = new createjs.Bitmap("terrain/" + this.terrainFileMap[terrain] + ".png");
      } else {
        console.log("missing " + terrain + " file");
        terrainView = new createjs.Shape();
        terrainView.graphics.beginFill("red").drawCircle(0, 0, 90);
      }
      return terrainView;
    },
    getFeatureView: function(feature) {
      var featureView, terrainView;
      if (this.featureFileMap[feature] != null) {
        featureView = new createjs.Bitmap("feature/" + this.featureFileMap[feature] + ".png");
      } else {
        console.log("missing " + feature + " file");
        terrainView = new createjs.Shape();
        terrainView.graphics.beginFill("red").drawCircle(0, 0, 90);
      }
      return featureView;
    },
    fromModel: function(model) {
      var container, currentFeatureView, currentTerrainView, _ref,
        _this = this;
      container = new createjs.Container();
      _ref = this.transformByParity([0, 0], model.position), container.x = _ref[0], container.y = _ref[1];
      currentTerrainView = null;
      currentFeatureView = null;
      container.updateByModel = function(model) {
        var newFeatureView, newTerrainView;
        newTerrainView = _this.getTerrainView(model.terrain);
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
        return currentFeatureView = newFeatureView;
      };
      model.addObserver(function() {
        return container.updateByModel(model);
      });
      container.onClick = function(event) {
        if (event.nativeEvent.altKey) {
          return model.cycleFeature();
        } else {
          return model.cycleTerrain();
        }
      };
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
      hintView.graphics.beginFill("#FFF").drawCircle(0, 0, 60);
      _ref = TileView.transformByParity(centerPoint, hexordinate), hintView.x = _ref[0], hintView.y = _ref[1];
      hintOver = new createjs.Shape();
      hintOver.graphics.beginStroke("green").drawCircle(0, 0, 50);
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

  MageKnight.TileView = TileView;

  MageKnight.HintView = HintView;

  MageKnight.TileViewCache = TileViewCache;

}).call(this);
