Template.selectCurriculum.helpers {
  curriculums: ()->
    console.log "gettin ght curricula"
    console.log Curriculum.find({})
    return Curriculum.find({})
}

Template.selectCurriculum.onRendered ()->
  fview = FView.from this
  #fview.node._object.hide()
  surface = FView.byId("selectConditionSurface").surface
  console.log surface
  surface.on "deploy", ()->
    console.log "deployed"
    console.log $("select")
    #$('select').material_select()

Template.selectCurriculumFooter.events {
  'click #submitCurriculumSelect':(event, template) ->
    console.log "clicked"
    condition = $("input[name=curriculum]:selected")
    console.log condition

}
