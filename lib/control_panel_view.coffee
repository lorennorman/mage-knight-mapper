class ControlPanelView extends createjs.Container
  constructor: (@cameraControlsView) ->
    super()

    @doLayout()
    @addBackground()
    @addHideShowButton()
    @addNewButton()
    @addMovementOverlay()
    @addDayNightButtons()
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

  addDayNightButtons: () ->
    dayButton = new MageKnight.ImageButton(normal: "day", action: => MageKnight.setDay())    
    dayButton.x = 37
    dayButton.y = 237
    @addChild dayButton
    nightButton = new MageKnight.ImageButton(normal: "night", action: => MageKnight.setNight())    
    nightButton.x = 168
    nightButton.y = 237
    @addChild nightButton

  addCamera: () ->
    @cameraControlsView.x = 20
    @addChild(@cameraControlsView)

MageKnight.ControlPanelView = ControlPanelView