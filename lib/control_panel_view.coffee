class ControlPanelView extends createjs.Container
  constructor: (@cameraView) ->
    super()

    @doLayout()
    @addBackground()
    @addHideShowButton()
    @addNewButton()
    @addMovementOverlay()
    @addCamera()

  scaleX: 2
  scaleY: 2
  hidden: true

  collapsedCoordinates:
    x: 1280
    y: 0

  dimensions:
    x: 884
    y: 0
    width: 396
    height: 480

  toggleVisibility: () =>
    @hidden = !@hidden
    @doLayout()

  doLayout: () ->
    if @hidden
      createjs.Tween.get(this).to({alpha: .5}, 800)
      createjs.Tween.get(this).to({x: @collapsedCoordinates.x}, 1000, createjs.Ease.quintOut)
      createjs.Tween.get(this).to({y: @.collapsedCoordinates.y}, 1000, createjs.Ease.quintOut)
    else
      createjs.Tween.get(this).to({alpha: 1}, 800)
      createjs.Tween.get(this).to({x: @dimensions.x}, 1000, createjs.Ease.quintOut)
      createjs.Tween.get(this).to({y: @dimensions.y}, 1000, createjs.Ease.quintOut)

  addBackground: () ->
    background = new createjs.Bitmap("#{MageKnight.Loader.filePath}interface/background.png")
    @addChild(background)

  addHideShowButton: () ->
    hsButton = new MageKnight.ImageButton(normal: "lefttab", noMouseOver: true, action: @toggleVisibility)
    hsButton.x = -30
    @addChild(hsButton)

  addNewButton: () ->
    newButton = new MageKnight.ImageButton(normal: "new", action: => MageKnight.newMap() if confirm("Are you sure?"))
    newButton.x = 10
    newButton.y = 35
    @addChild(newButton)

  addMovementOverlay: () ->
    moveButton = new MageKnight.ImageButton(normal: "movement", action: => MageKnight.toggleMove())
    moveButton.x = 10
    moveButton.y = 100
    @addChild(moveButton)

  addCamera: () ->
    @cameraView.x = 20
    @addChild(@cameraView)

MageKnight.ControlPanelView = ControlPanelView