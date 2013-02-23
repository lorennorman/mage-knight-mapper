class Camera
  constructor: (@view) ->

  left:    => @view.x += 50
  right:   => @view.x -= 50
  up:      => @view.y += 50
  down:    => @view.y -= 50
  zoomIn:  => @view.scaleX = @view.scaleY *= 1.1
  zoomOut: => @view.scaleX = @view.scaleY *= 0.9

MageKnight.Camera = Camera