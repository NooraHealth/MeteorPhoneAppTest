Template.selectCurriculum.helpers {
  getId: ()->
    return this._id

  curriculums: ()->
    return Curriculum.find({title:{$ne: "Start a New Curriculum"}})
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
    oldId = Meteor.user().getCurriculumId()
    if oldId == curriculumId
      console.log "Select curriculums started"
      console.log "going home"
      Router.go "home"
    else
      Meteor.user().setCurriculum curriculumId
      console.log "Just set the curriculum, going home"
      Router.go "home"
      #Meteor.call 'contentEndpoint', (err, endpoint)->
        #downloader = new ContentInterface(Meteor.user().getCurriculum(), endpoint)
        #promise = downloader.clearContentDirectory()
        #promise.then ()->
          #Router.go 'home'
        #promise.catch (err)->
          #alert "There was an error selecting the new curriculum"
          #Meteor.logout()

}
