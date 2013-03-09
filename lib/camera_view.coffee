class CameraView extends createjs.Container
  constructor: (@containedView) ->
    super()
    @addChild(@containedView)

  left:    => @containedView.y += 50
  right:   => @containedView.y -= 50
  up:      => @containedView.x -= 50
  down:    => @containedView.x += 50
  zoomIn:  => @containedView.scaleX = @containedView.scaleY *= 1.1
  zoomOut: => @containedView.scaleX = @containedView.scaleY *= 0.9

MageKnight.CameraView = CameraView