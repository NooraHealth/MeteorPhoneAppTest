class @Grid

  @X = 0
  @Y = 1
  
  constructor: (@_numItems, @_perRow, @_size, @_margin, @_edgeMargin)->
    @_numRows = @.getNumRows()

  getRow: ( index )->
    return Math.floor( index / @._perRow )

  getNumRows: ->
    return Math.ceil( @._numItems / @._perRow )

  getCol: ( index )->
    return index %% @._perRow

  getPosition: ( index, itemSize )->
    return index * itemSize + ( @._margin * index ) + @._edgeMargin

  getAvailableSpace: ( axis )->
    return @._size[axis] - @._edgeMargin * 2 - @._margin * ( @._numItems - 1)
  
  location: ( row, col, itemSize )->
    x = @.getPosition col, itemSize[Grid.X]
    y = @.getPosition row, itemSize[Grid.Y]
    return {
      x: x
      y: y
    }

