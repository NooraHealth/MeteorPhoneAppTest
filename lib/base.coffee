class @Base
  constructor: ()->

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

  log: (tag, type,message, objects...)->
    a = null
    tag ?= ""
    if type=="DEBUG" or type=="ERROR"
      a = console.debug
    if type=="WARN"
      a = console.warn
    if type=="INFO"
      a = console.info
    if type=="LOG"
      a = console.log
    else
      a = console.log

    a type.concat( " " + tag+ " " + " : " +message)
    for obj in objects
      a obj
