class Camera
  constructor: (@view) ->

  left:    => @view.y += 50
  right:   => @view.y -= 50
  up:      => @view.x -= 50
  down:    => @view.x += 50
  zoomIn:  => @view.scaleX = @view.scaleY *= 1.1
  zoomOut: => @view.scaleX = @view.scaleY *= 0.9

MageKnight.Camera = Camera