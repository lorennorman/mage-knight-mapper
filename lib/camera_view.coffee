class CameraView extends createjs.Container
  constructor: (@camera) ->
    super()

    left = new MageKnight.Button("<", @camera.left)
    left.x = 0
    left.y = 40

    right = new MageKnight.Button(">", @camera.right)
    right.x = 40
    right.y = 40

    up = new MageKnight.Button("^", @camera.up)
    up.x = 20
    up.y = 25

    down = new MageKnight.Button("V", @camera.down)
    down.x = 20
    down.y = 55

    zoomIn = new MageKnight.Button "+", @camera.zoomIn
    zoomIn.x = 10

    zoomOut = new MageKnight.Button "-", @camera.zoomOut
    zoomOut.x = 35

    @addChild(left, right, up, down, zoomIn, zoomOut)

MageKnight.CameraView = CameraView