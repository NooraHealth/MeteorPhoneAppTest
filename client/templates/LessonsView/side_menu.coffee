Template.sideMenu.helpers
  curriculums: ()->
    return Curriculum.find({title:{$ne: "Start a New Curriculum"}})

Template.listItem.events
  'click': ( e , template )->
    data = Template.currentData()
    Scene.get().setCurriculum Curriculum.findOne {_id: data._id}
    App.closePanel()


