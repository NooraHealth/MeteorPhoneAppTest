Template.selectCurriculum.helpers {
  curriculums: ()->
    console.log "gettin ght curricula"
    console.log Curriculum
    console.log Curriculum.find({})
    docs = Curriculum.find({})
    docs.forEach (doc)->
      console.log doc
    return Curriculum.find({})
}

Template.selectCurriculum.onRendered ()->
  console.log "in the on renderedslideWindowRig"
  fview = FView.from this
  console.log fview
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
    curriculumId = $("input[name=curriculum]:checked").val()
    Meteor.users.update {_id: Meteor.user()._id}, {$set: {"profile.curriculumId": curriculumId}}
    console.log curriculumId
    Router.go "home"
}
