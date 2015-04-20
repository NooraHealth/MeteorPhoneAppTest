Template.nextBtn.events
  "click #nextbtn": ()->
    index = Session.get "current module index"
    currLesson = Session.get "current lesson"
    modulesSequence = Session.get "modules sequence"
    
    fview = FView.byId "module"
    console.log "fview on clicking nect: ", fview
    fview.destroy()
    
    if index < modulesSequence.length
      Router.go "ModulesSequence", {nh_id: currLesson.nh_id, index: index+1}
    else
      currentChapter = Session.get "current chapter index"
      Session.set "current chapter index", currentChapter + 1
      Router.go "home"

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
