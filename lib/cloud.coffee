class Cloud
  constructor: (cloudNum) ->
    cloudFile = "#{MageKnight.Loader.filePath}clouds/cloud#{cloudNum}.png"
    (_ this).extend new createjs.Bitmap(cloudFile)

    Cloud.getTicker().items.push this

  _speedX: 0
  _speedY: 0
  _minX: -350
  _maxX: 1440
  _minY: -200
  _maxY: 1100
  update: () ->
    if @x > @_maxX
      @x = @_minX
    if @y < @_minY
      @y = @_maxY

    @x += @_speedX
    @y += @_speedY

Cloud.random = ->
  cloudNum       = Math.ceil(Math.random()*6)
  cloud          = new Cloud(cloudNum)
  cloud.x        = Math.random() * cloud._maxX
  cloud.y        = Math.random() * cloud._maxY
  cloud.scaleX   = cloud.scaleY = .33 + Math.random() / 4
  cloud.alpha    = .33 + Math.random() / 4
  cloud.rotation = 315
  totalSpeed     = .5 + Math.random()*2
  cloud._speedX  = totalSpeed / 2
  cloud._speedY  = -totalSpeed / 4
  cloud

Cloud.getTicker = ->
  @_ticker ?= do ->
    @items = []

    setInterval =>
      item.update() for item in @items
    , 50

    items: @items

MageKnight.Cloud = Cloud
