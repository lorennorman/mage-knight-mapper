class CameraView extends createjs.Container
  constructor: (@camera) ->
    super()

    left = new MageKnight.ImageButton(normal: "left", action: @camera.left)
    left.x = 6
    left.y = 215

    right = new MageKnight.ImageButton(normal: "right", action: @camera.right)
    right.x = 110
    right.y = 215

    up = new MageKnight.ImageButton(normal: "up", action: @camera.up)
    up.x = 55
    up.y = 165

    down = new MageKnight.ImageButton(normal: "down", action: @camera.down)
    down.x = 55
    down.y = 270

    zoomIn = new MageKnight.ImageButton normal: "zoomin", action: @camera.zoomIn
    zoomIn.x = 20
    zoomIn.y = 400

    zoomOut = new MageKnight.ImageButton normal: "zoomout", action: @camera.zoomOut
    zoomOut.x = 100
    zoomOut.y = 400

    @addChild(left, right, up, down, zoomIn, zoomOut)

MageKnight.CameraView = CameraView