Template.selectCurriculum.helpers {
  getId: ()->
    return this._id

  curriculums: ()->
    return Curriculum.find({})
}

Template.selectCurriculum.onRendered ()->
  fview = FView.from this
  #fview.node._object.hide()
  surface = FView.byId("selectConditionSurface").surface

  #surface.setProperties {
    #color: 'black'
  #}
  surface.on "deploy", ()->
    console.log "deployed"
    #$('select').material_select()

Template.selectCurriculumFooter.events {
  'click #submitCurriculumSelect':(event, template) ->
    console.log "clicked"
    curriculumId = $("input[name=curriculum]:checked").val()
    Meteor.user().setCurriculum curriculumId
    console.log curriculumId
    Router.go "home"
}
