class @Utilities

  @getRow: ( index, numPerRow )->
    return Math.floor( index / numPerRow )

  @getNumRows: ( numItems, numPerRow )->
    return Math.ceil( numItems / numPerRow )

  @getCol: ( index, numPerRow )->
    return index %% numPerRow

  @getPosition: ( index, size, margin, edgeMargin )->
    return index * size + ( margin * index ) + edgeMargin

  @getAvailableSpace: ( numItems, margin, edgeMargin, size )->
    return size - edgeMargin * 2 - margin * ( numItems - 1)
  
  @toggleClass: ( domElement, klass )->
    if domElement.hasClass klass
      domElement.removeClass klass
    else
      domElement.addClass klass


