Template.nextBtn.events
  "click #nextbtn": ()->
    index = Session.get "current module index"
    Session.set "current module index", index + 1

Template.nextBtn.helpers
  ###
  # Returns true if the next item is the next chapter
  ###
  nextChapter: ()->

  ###
  # Returns true if the next item is the next lesson
  ###
  nextLesson: ()->

  ###
  # Returns true if the next item is the next section
  ###
  nextSection: ()->

  ###
  # returns the title of the next chapter
  ###
  nextChapterTitle: ()->

  ###
  # Returns the title of the next section
  ###
  nextSectionTitle: ()->

  ###
  # Returns the title of the next lesson
  ###
  nextLessonTitle: ()->
