Router.map ()->
  
  ###
  # Home
  # Displays all chapters in curriculum
  ###
  this.route '/', {
    path: '/'
    name: 'home'
    template: 'home'
    yieldTemplates: {
      'footer': {to:"footer"}
    }
    layoutTemplate: 'layout'
    onBeforeAction: ()->
      if !Meteor.user()
        this.next()
      else
        console.log "ROUTING TO HOME"
        if not Meteor.user().curriculumIsSet()
          Router.go "selectCurriculum"
        console.log "Not going to get curriculum"
        if Meteor.isCordova and not Meteor.user().contentLoaded()
          console.log "cordova!"
          console.log Meteor.user()
          console.log "The user curriculum: ", Meteor.user().getCurriculum()
          mediaUrl = Meteor.call "mediaUrl", (err, mediaUrl)->
            console.log "Just set the media url", mediaUrl
            downloader = new ContentDownloader(Meteor.user().getCurriculum(), mediaUrl)
            onSuccess = (entry)->
              console.log ""
              console.log "Promise was successful! in callback"
              console.log entry
              console.log ""
            onError = (err)->
              console.log ""
              console.log "Promised FAILED"
              console.log err
              console.log ""
            downloader.loadContent(onSuccess, onError)
        else
          mediaUrl = Meteor.call "mediaUrl"
          console.log "Just set the media url", mediaUrl
          Session.set "media url", mediaUrl

        this.next()

    data: ()->
      if this.ready() and Meteor.user()
        curr = Curriculum.findOne({_id: Meteor.user().profile.curriculumId})
        console.log "This si the curriculum"
        if curr
          Session.set "current chapter", null
          Session.set "current lesson", null
          Session.set "current module index", null
          Session.set "module sequence", null
          Session.set "sections map", {}
          Session.set "current sections", null
          chapters =  curr.getLessonDocuments()
          Session.set "chapters sequence", chapters
          return {chapters: chapters}
  }

  this.route '/selectCurriculum', {
    path: '/selectCurriculum'
    layoutTemplate: 'layout'
    name: 'selectCurriculum'
    yieldTemplates: {
      'selectCurriculumFooter': {to:"footer"}
    }
    onBeforeAction: ()->
      Session.set "current transition", "opacity"
      Meteor.subscribe "curriculums"
      this.next()
  }

  ###
  # Module Sequence
  ###
  this.route '/modules/:nh_id', {
    path: '/modules/:nh_id'
    layoutTemplate: 'layout'
    name: 'ModulesSequence'
    template: "module"
    yieldTemplates: {
      'moduleFooter': {to:"footer"}
    }
    onBeforeAction: ()->
      Session.set "current transition", "slideWindowRight"
      this.next()
    data: () ->
      if this.ready()
        lesson = Lessons.findOne {nh_id: this.params.nh_id}
        Session.set "current lesson", lesson
        modules = lesson.getModulesSequence()
        Session.set "modules sequence", modules
        Session.set "current module index",0
        Session.set "correctly answered", []
        Session.set "incorrectly answered", []
        Session.set "next button is hidden", false
        return {modules:  modules  }
        
  }


  ###
  # Refresh the content
  ###
  this.route '/refreshcontent', {
    path: '/refreshcontent'
    data: ()->
      Meteor.call "refreshContent", ()->
        console.log "Yey called refresh"
  }


Router.configure {
  progressSpinner:false

}
