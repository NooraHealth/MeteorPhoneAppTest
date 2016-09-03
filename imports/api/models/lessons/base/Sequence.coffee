
class Sequence

  constructor: (@items, @areEqual) ->
    # Validate the arguments
    new SimpleSchema({
      areEqual: {type: Function}
    }).validate {
      areEqual: @areEqual
    }

    @state = new ReactiveDict()
    @state.set {
      index: -1
    }

  getIndex: ->
    return @state.get "index"

  getCurrentItem: ->
    if not @getIndex()?
      return null
    return @getItems()[@getIndex()]

  getItems: ->
    return @items

  onLast: ->
    return @getIndex() == @getItems().length - 1

  goTo: ( index )->
    @state.set "index", index

  goToNext: ->
    if @onLast()
      @reset()
    else
      index = @getIndex()
      if not index?
        @goTo 0
      @goTo ++index

  getNext: ->
    index = @getIndex()
    if @onLast()
      return null
    else
      return @getItems()[index + 1]

  reset: ->
    @goTo null

  isNext: ( item )->
    nextItem = @getNext()
    return @areEqual item, nextItem

  isCurrent: ( item )->
    return @areEqual( item, @getCurrentItem() )
    

module.exports.Sequence = Sequence
