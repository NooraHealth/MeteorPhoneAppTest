Template.lessonsView.helpers
  curriculumTitle: ()->
    return Scene.get().getCurriculum().title

  lessons: ()->
    return Scene.get().getLessons()

