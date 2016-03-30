Template.sideMenu.helpers
  curriculums: ()->
    return Curriculums.find({title:{$ne: "Start a New Curriculum"}})

Template.listItem.events
  'click': ( e , template )->
    console.log "List item clicked"
    data = Template.currentData()
    Scene.get().setCurriculum Curriculums.findOne {_id: data.curriculum._id}
    App.closePanel()


