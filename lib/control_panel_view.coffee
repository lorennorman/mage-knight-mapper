class ControlPanelView extends createjs.Container
  constructor: (@cameraView, newButton) ->
    super()
    @dimensions =
      x: 1082
      y: 0
      width: 198
      height: 480

    @collapsedCoordinates =
      x: 1280
      y: 0

    @hidden = true

    @doLayout()
    @addBackground()
    @addHideShowButton()
    @addMovementOverlay()
    @addCamera()

    newButton.x = 10
    newButton.y = 35
    @addChild(newButton)

  doLayout: () ->
    if @hidden
      @x = @collapsedCoordinates.x
      @y = @collapsedCoordinates.y
    else
      @x = @dimensions.x
      @y = @dimensions.y

  addBackground: () ->
    background = new createjs.Bitmap("#{MageKnight.Loader.filePath}interface/background.png")
    # shape = new createjs.Shape()
    # shape.graphics.beginFill("lightgray").drawRect(0, 0, @dimensions.width, @dimensions.height)
    # shape.alpha = 0.4
    @addChild(background)

  addMovementOverlay: () ->
    moveButton = new MageKnight.ImageButton(normal: "movement", action: => MageKnight.toggleMove())
    moveButton.x = 10
    moveButton.y = 100
    @addChild(moveButton)

  addHideShowButton: () ->
    hsButton = new MageKnight.ImageButton(normal: "lefttab", noMouseOver: true, action: => @hidden = !@hidden; @doLayout())
    hsButton.x = -30
    @addChild(hsButton)

  addCamera: () ->
    @cameraView.x = 20
    @addChild(@cameraView)

MageKnight.ControlPanelView = ControlPanelView