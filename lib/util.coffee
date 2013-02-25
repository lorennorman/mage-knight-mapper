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
    grasslands = @promptUntilValid("How many Grassland tiles?", _.size(MageKnight.TileSet.Grassland))
    nonCity = @promptUntilValid("How many Non-City Core tiles?", _.size(MageKnight.TileSet.Core.NonCity))
    city = @promptUntilValid("How many City Core tiles?", _.size(MageKnight.TileSet.Core.City))

    MageKnight.TileSet.shuffle(
      grasslands: grasslands,
      coreNonCity: nonCity,
      coreCity: city)