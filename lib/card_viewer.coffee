class CardViewer extends createjs.Container
  constructor: (exitFunc) ->
    super()
    @card = new createjs.Bitmap
    cardWidth = 697
    cardHeight = 497
    @card.x = cardWidth
    @card.regX = cardWidth/2
    @card.y = cardHeight - 20
    @card.regY = cardHeight/2
    @card.rotation = 90
    # @card.scaleX = @card.scaleY = 1.75
    @addChild @card
    cancelButton = new MageKnight.ImageButton(normal: "x", action: exitFunc)
    cancelButton.x = cardWidth*3/2 - 60
    cancelButton.y = cardHeight*3/2 + 25
    cancelButton.rotation = 90
    @addChild cancelButton

  setCardByModel: (model) ->
    img = new Image
    img.src = "#{MageKnight.Loader.filePath}/interface/cards/#{model}.png"
    @card.image = img

MageKnight.CardViewer = CardViewer