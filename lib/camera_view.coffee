class CameraView extends createjs.Container
  constructor: (@camera) ->
    super()

    left = new MageKnight.ImageButton(normal: "left", action: @camera.left)
    left.x = 525
    left.y = 145

    right = new MageKnight.ImageButton(normal: "right", action: @camera.right)
    right.x = 675
    right.y = 145

    up = new MageKnight.ImageButton(normal: "up", action: @camera.up)
    up.x = 600
    up.y = 70

    down = new MageKnight.ImageButton(normal: "down", action: @camera.down)
    down.x = 600
    down.y = 215

    zoomIn = new MageKnight.ImageButton normal: "zoomin", action: @camera.zoomIn
    zoomIn.x = 800
    zoomIn.y = 125

    zoomOut = new MageKnight.ImageButton normal: "zoomout", action: @camera.zoomOut
    zoomOut.x = 800
    zoomOut.y = 195

    @addChild(left, right, up, down, zoomIn, zoomOut)

MageKnight.CameraView = CameraView