class Button extends createjs.Container
  constructor: (text, trigger) ->
    super()

    background = new createjs.Shape()
    background.graphics.beginFill("666").drawCircle(10, 10, 10)
    @addChild(background)

    overBackground = new createjs.Shape()
    overBackground.graphics.beginFill("888").drawCircle(10, 10, 10)

    outline = new createjs.Shape()
    outline.graphics.beginStroke("333").drawCircle(10, 10, 10)
    @addChild(outline)

    label = new createjs.Text(text, "20px Arial bold")
    label.x = 3
    label.y = -1
    @addChild(label)

    @addEventListener "click", trigger
    @addEventListener "mouseover", =>
      @removeChild(background)
      @addChildAt(overBackground, 0)
    @addEventListener "mouseout", =>
      @removeChild(overBackground)
      @addChildAt(background, 0)

class ImageButton extends createjs.Container
  constructor: (opts={}) ->
    super()

    normalFile = "#{MageKnight.Loader.filePath}interface/buttons/#{opts.normal}_up.png"
    normalImage = new createjs.Bitmap(normalFile)
    @addChild(normalImage)

    @addEventListener "click", opts.action

    unless opts.noMouseOver?
      overFile = "#{MageKnight.Loader.filePath}interface/buttons/#{opts.normal}_over.png"
      overImage = new createjs.Bitmap(overFile)

      @addEventListener "mouseover", =>
        @removeChild(normalImage)
        @addChild(overImage)
      @addEventListener "mouseout", =>
        @removeChild(overImage)
        @addChild(normalImage)

MageKnight.Button = Button
MageKnight.ImageButton = ImageButton