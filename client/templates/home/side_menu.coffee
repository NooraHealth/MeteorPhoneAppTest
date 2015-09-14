Template.sideMenu.helpers
  curriculums: ()->
    return Curriculum.find({title:{$ne: "Start a New Curriculum"}})

Template.sideMenu.events
  'click .item': ( e )->
    console.log e

Template.listItem.events
  'click': ( e , template )->
    console.log Template.currentData()
    console.log e
    console.log template
    data = Template.currentData()
    Scene.get().setCurriculum Curriculum.findOne {_id: data._id}


