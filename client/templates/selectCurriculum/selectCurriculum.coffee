Template.selectCurriculum.helpers {
  curriculums: ()->
    console.log "HEre are all the curriculums"
    console.log Curriculum.find({})
    cursor = Curriculum.find({})
    console.log "Found all the curriculums and here is the cursor: ", cursor
    console.log cursor
    cursor.forEach (el)->
      console.log "FOR EACH LOOP"
      console.log el
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
