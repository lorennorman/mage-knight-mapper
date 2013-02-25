class ValidationError extends MageKnight.Error

class HexCoordinate
  constructor: (array) ->
    @array = HexCoordinate.validate(array)

  toString: -> "Hexordinate[#{@array.join()}]"
  isOrigin: -> @array.length is 0

  add: (hexordinate) ->
    ary = @array.concat hexordinate.array
    new HexCoordinate(ary)

  getAdjacencies: () ->
    [
      new HexCoordinate(@array.concat(0)),
      new HexCoordinate(@array.concat(1)),
      new HexCoordinate(@array.concat(2)),
      new HexCoordinate(@array.concat(3)),
      new HexCoordinate(@array.concat(4)),
      new HexCoordinate(@array.concat(5))
    ]

  getGroupAdjacencies: () ->
    [
      new HexCoordinate(@array.concat([0, 0, 1])),
      new HexCoordinate(@array.concat([1, 1, 2])),
      new HexCoordinate(@array.concat([2, 2, 3])),
      new HexCoordinate(@array.concat([3, 3, 4])),
      new HexCoordinate(@array.concat([4, 4, 5])),
      new HexCoordinate(@array.concat([5, 5, 0]))
    ]
    
HexCoordinate.validate = (array) ->
  array = array.array or array
  coordinates = [0..5]

  isValidCoordinate = (el) ->
    throw "Invalid index: #{el}" unless coordinates.indexOf(el) > -1

  array.every(isValidCoordinate)

  # [ [0, 0], [1, 1, 1], [2], [3, 3], ...]
  groups = coordinates.map (coordinate) ->
    array.filter (el) -> el is coordinate

  counts = groups.map (group) -> group.length

  truncateToMin = (groupsToReduce, groupToAdd=null) ->
    numToTransfer = Math.min.apply(null, (counts[group] for group in groupsToReduce))    

    counts[group] -= numToTransfer for group in groupsToReduce
    counts[groupToAdd] += numToTransfer if groupToAdd?

  # this is my primary assumption about hex charting
  truncateToMin([0, 2, 4])
  truncateToMin([1, 3, 5])
  truncateToMin([0, 3])
  truncateToMin([1, 4])
  truncateToMin([2, 5])

  truncateToMin([0, 2], 1)
  truncateToMin([1, 3], 2)
  truncateToMin([2, 4], 3)
  truncateToMin([3, 5], 4)
  truncateToMin([4, 0], 5)
  truncateToMin([5, 1], 0)

  answer = []
  for count, coordinate in counts
    answer.push(coordinate) while (count -= 1) >= 0

  answer

HexCoordinate.ValidationError = ValidationError
MageKnight.HexCoordinate = HexCoordinate