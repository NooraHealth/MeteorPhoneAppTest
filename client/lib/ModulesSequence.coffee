class ModulesSequence
  constructor: ( lesson )->
    console.log "Making a modules sequence"

  start: ()->
    Router.go "modules.show", lesson._id

