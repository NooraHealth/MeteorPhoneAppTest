Template.sideMenu.helpers
  curriculums: ()->
    return Curriculum.find({title:{$ne: "Start a New Curriculum"}})

Template.sideMenu.events
  'click .item': ( e )->
    id = $(e.target).attr "id"
    Scene.get().setCurriculum Curriculum.findOne {_id: id}

