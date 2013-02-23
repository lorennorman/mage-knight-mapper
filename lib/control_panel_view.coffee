class ControlPanelView extends createjs.Container
  constructor: (@cameraView, newButton) ->
    super()
    @dimensions =
      x: 460
      y: 0
      width: 180
      height: 480

    @collapsedCoordinates =
      x: 620
      y: 0

    @hidden = true

    @doLayout()
    @addBackground()
    @addHideShowButton()
    @addCamera()

    newButton.x = 30
    newButton.y = @dimensions.height - 30
    @addChild(newButton)

  doLayout: () ->
    if @hidden
      @x = @collapsedCoordinates.x
      @y = @collapsedCoordinates.y
    else
      @x = @dimensions.x
      @y = @dimensions.y

  addBackground: () ->
    shape = new createjs.Shape()
    shape.graphics.beginFill("lightgray").drawRect(0, 0, @dimensions.width, @dimensions.height)
    shape.alpha = 0.4
    @addChild(shape)

  addHideShowButton: () ->
    hsButton = new MageKnight.Button(" ||", => @hidden = !@hidden; @doLayout())
    hsButton.y = @dimensions.height/2
    @addChild(hsButton)

  addCamera: () ->
    @cameraView.x = 20
    @addChild(@cameraView)

MageKnight.ControlPanelView = ControlPanelView