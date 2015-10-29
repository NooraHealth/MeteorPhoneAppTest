Meteor.startup ()->
  curr = Session.get "curriculum id"
  if curr
    Scene.get().setCurriculum Curriculum.findOne { _id: curr }

  Meteor.subscribe "all"
