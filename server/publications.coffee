Meteor.publish "curriculums", ()->
  return Curriculum.find({})


