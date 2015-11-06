Template.sideMenu.helpers
  curriculums: ()->
    return Curriculum.find({title:{$ne: "Start a New Curriculum"}})

Template.listItem.events
  'click': ( e , template )->
    data = Template.currentData()
    console.log "This is the current data"
    console.log data
    Scene.get().setCurriculum Curriculum.findOne {_id: data._id}
    App.closePanel()


