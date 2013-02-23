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

MageKnight.Button = Button