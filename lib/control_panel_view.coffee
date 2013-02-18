class ControlPanelView extends createjs.Container
  constructor: (mapView) ->
    super()
    @dimensions =
      x: 580
      y: 0
      width: 60
      height: 480

    @doLayout()
    @addBackground()
    @addCameraButtons(mapView)

  doLayout: () ->
    @x = @dimensions.x
    @y = @dimensions.y

  addBackground: () ->
    shape = new createjs.Shape()
    shape.graphics.beginFill("lightgray").drawRect(0, 0, @dimensions.width, @dimensions.height)
    @addChild(shape)

  addCameraButtons: (mapView) ->
    left = new Button("<", -> mapView.x -= 50)
    left.x = 0
    left.y = 40
    right = new Button(">", -> mapView.x += 50)
    right.x = 40
    right.y = 40
    up = new Button("^", -> mapView.y -= 50)
    up.x = 20
    up.y = 25
    down = new Button("V", -> mapView.y += 50)
    down.x = 20
    down.y = 55

    zoomIn = new Button "+", ->
      mapView.scaleX = mapView.scaleY *= 1.1
    zoomIn.x = 10

    zoomOut = new Button "-", ->
      mapView.scaleX = mapView.scaleY *= .9
    zoomOut.x = 35

    @addChild(left, right, up, down, zoomIn, zoomOut)

class Button extends createjs.Container
  constructor: (text, trigger) ->
    super()

    background = new createjs.Shape()
    background.graphics.beginFill("666").drawCircle(10, 10, 10)
    @addChild(background)

    overBackground = new createjs.Shape()
    overBackground.graphics.beginFill("888").drawCircle(10, 10, 10)

    label = new createjs.Text(text, "20px Arial bold")
    label.x = 3
    label.y = -1
    @addChild(label)

    @addEventListener "click", trigger
    @addEventListener "mouseover", =>
      @removeChild(background)
      @addChildAt(overBackground, 0)
    @addEventListener "mouseout", =>
      @removeChild(overBackground)
      @addChildAt(background, 0)


MageKnight.ControlPanelView = ControlPanelView