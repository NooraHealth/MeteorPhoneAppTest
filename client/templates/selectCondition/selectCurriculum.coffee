Template.selectCurriculum.helpers {
  curriculums: ()->
    return Curriculum.find({})
}

Template.selectCurriculum.onRendered ()->
  fview = FView.from this
  #fview.node._object.hide()
  surface = FView.byId("selectConditionSurface").surface
  surface.on "deploy", ()->
    console.log "deployed"
    console.log $("select")
    #$('select').material_select()

Template.selectCurriculumFooter.events {
  'click #submitCurriculumSelect':(event, template) ->
    console.log "clicked"
    curriculumId = $("input[name=curriculum]:checked").val()
    Meteor.users.update {_id: Meteor.user()._id}, {$set: {"profile.curriculumId": curriculumId}}
    console.log curriculumId
    Router.go "home"
}
