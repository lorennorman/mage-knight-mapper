class ControlPanelView extends createjs.Container
  constructor: (@cameraView) ->
    super()

    @doLayout()
    @addBackground()
    @addHideShowButton()
    @addNewButton()
    @addMovementOverlay()
    @addCamera()

  hidden: true
  rotation: 90

  collapsedCoordinates:
    x: 1815
    y: 0

  dimensions:
    x: 1440
    y: 0
    width: 375
    height: 900

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
    hsButton = new MageKnight.ImageButton(normal: "blade", noMouseOver: true, action: @toggleVisibility)
    hsButton.y = 375
    @addChild(hsButton)

  addNewButton: () ->
    newButton = new MageKnight.ImageButton(normal: "new", action: => MageKnight.newMap() if confirm("Are you sure?"))
    newButton.x = 37
    newButton.y = 67
    @addChild(newButton)

  addMovementOverlay: () ->
    moveButton = new MageKnight.ImageButton(normal: "movement", action: => MageKnight.toggleMove())
    moveButton.x = 37
    moveButton.y = 152
    @addChild(moveButton)

  addCamera: () ->
    @cameraView.x = 20
    @addChild(@cameraView)

MageKnight.ControlPanelView = ControlPanelView