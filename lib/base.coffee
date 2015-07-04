class @Base
  constructor: ()->
    console.log "Being called"

  @extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @[key] = value
    obj.extended?.apply(@)
    @

  @include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @::[key] = value
    obj.included?.apply(@)
    @
  log: (tag, type, messages...)->
    a = null
    tag ?= ""
    if type=="DEBUG"
      a = console.debug
    if type=="WARN"
      a = console.warn
    if type=="INFO"
      a = console.info
    if type=="LOG"
      a = console.log
    else
      a = console.log

    console.log "This is the function: "
    console.log a
    for message in messages
      str = tag.concat( ": " ).concat( message )
      a str
