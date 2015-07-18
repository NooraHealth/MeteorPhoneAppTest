class @ModuleSequence
  instance = null
  @get: (modules)->
    instance ?= new PrivateClass(modules)

  class PrivateClass
    constructor: (@modules)->

    hasAllCorrectAnswers: ()=>
      incorrectlyAnswered = Session.get "incorrectly answered"
      correctlyAnswered = Session.get "correctly answered"
      modulesSequence = Session.get "modules sequence"
      return incorrectlyAnswered.length <= 0 and (correctlyAnswered.length == modulesSequence.length)

    isLastModuleInSeries: ()=>
      index = Session.get "current module index"
      modulesSequence = Session.get "modules sequence"
      return index+1 < modulesSequence.length

    hasAttemptedAllModules: ()=>
      modulesSequence = Session.get "modules sequence"
      incorrectlyAnswered = Session.get "incorrectly answered"
      correctlyAnswered = Session.get "correctly answered"
      return correctlyAnswered.length + incorrectlyAnswered.length == modulesSequence.length

    recordModuleAsCorrectlyAnswered: ()=>
      index = Session.get "current module index"
      correctlyAnswered = Session.get "correctly answered"
      correctlyAnswered.push index
      Session.set "correctly answered", correctlyAnswered

    nextIncorrectModule: ()=>
      incorrectlyAnswered = Session.get "incorrectly answered"
      return incorrectlyAnswered[0]

    endSequence: ()=>
      currLesson = Session.get "current lesson"
      Meteor.user().updateLessonsComplete(currLesson)
      ModuleView.stopAllAudio()
      Router.go "home"

    allModulesComplete: ()=>
      numModules = (Session.get "modules sequence").length
      numCorrect = (Session.get "correctly answered").length
      currentModule = @.getCurrentModule()
      if !currentModule
        return false
      if ModuleSurface.isAQuestion(currentModule)
        return numCorrect == numModules
      else
        return numCorrect == numModules - 1

    currentModuleIndex: ()->
        return Session.get "current module index"

    gotToNextModule: ()->
      index = @.currentModuleIndex()
      currentModule = @.getCurrentModule()
      #if correctlyAnswered.length == modulesSequence.length
      if @.allModulesComplete()
        @.endSequence()
        return
      
      console.log "This is the current Module"
      if !ModuleSurface.isAQuestion(currentModule)
        @.recordModuleAsCorrectlyAnswered()
    
      if @.isLastModuleInSeries()
        nextModule = 0
        if @.hasAttemptedAllModules()
          nextModule = @.nextIncorrectModule()
        else
          nextModule = ++index

      else if !@.hasAllCorrectAnswers()
        nextModule = @.nextIncorrectModule()
      else
        @.endSequence()
        return

      ModuleView.stopAllAudio()
      Session.set "current module index", nextModule
      Session.set "success toast is visible", false
      Session.set "fail toast is visible", false
      Session.set "next button is hidden", NextModuleBtn.get().shouldHide()

      @.emitShowModuleEvent(nextModule)

    emitShowModuleEvent:  (module)=>
      fview = FView.byId "footer"
      surface = fview.view or fview.surface
      eventOutput = surface._eventOutput
      eventOutput.emit 'showModule', module

    getCurrentModule: ()->
      moduleSequence = Session.get "modules sequence"
      currentIndex = Session.get "current module index"
      console.log Session.get "modules sequence"
      console.log Session.get "current module index"
      if !moduleSequence? or !currentIndex?
        return

      console.log "Here is the module I'm returning"
      console.log moduleSequence[currentIndex]
      return moduleSequence[currentIndex]

