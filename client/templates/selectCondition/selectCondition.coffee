Template.selectCondition.helpers {
  curriculums: ()->
    console.log "gettin ght curricula"
    console.log Curriculum.find({})
    return Curriculum.find({})
}

Template.selectCondition.onRendered ()->
  fview = FView.from this
  #fview.node._object.hide()
  surface = FView.byId("selectConditionSurface").surface
  surface.on "deploy", ()->
    $('select').material_select()

  
