MageKnight.Util =
  promptUntilValid: (text, maxAnswer) ->
    answer = null
    text = text + " [1..#{maxAnswer}]"
    until answer?
      # brutish, hamfisted approach: prompt and parse!
      attempt = prompt(text)
      parsedAttempt = parseInt(attempt)

      # input validation...
      if _.isNaN parsedAttempt
        text = "Fail: #{attempt} could not be parsed as a number.\n" + text
      else if parsedAttempt <= 0
        text = "Fail: #{parsedAttempt} must be greater than zero.\n" + text
      # ...and bounding
      else if parsedAttempt > maxAnswer
        answer = maxAnswer
      else
        answer = parsedAttempt

    answer

  promptForTileStack: ->
    grasslands = @promptUntilValid("How many Grassland tiles?", _.size(MageKnight.TileStack.Grassland))
    nonCity = @promptUntilValid("How many Non-City Core tiles?", _.size(MageKnight.TileStack.Core.NonCity))
    city = @promptUntilValid("How many City Core tiles?", _.size(MageKnight.TileStack.Core.City))

    MageKnight.TileStack.shuffle(
      grasslands: grasslands,
      coreNonCity: nonCity,
      coreCity: city)

  getNightFilter: ->
    throw "You must have the external Filters included!" unless createjs.ColorMatrix and createjs.ColorMatrixFilter

    brightness = -5
    contrast = 0
    saturation = -35
    hue = -82
    colorMatrix = new createjs.ColorMatrix(brightness, contrast, saturation, hue)

    new createjs.ColorMatrixFilter(colorMatrix)

  makeObservable: (toObserve) ->
    (_ toObserve).extend(_.clone Observable)

Observable =
  getObservers: ->
    @observers ?= []

  addObserver: (observer) ->
    @getObservers().push observer
    @notifyObserver(observer)

  notifyObservers: () ->
    @notifyObserver(observer) for observer in @getObservers()

  notifyObserver: (observer) ->
    observer.notify?() or observer()
