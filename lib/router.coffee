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

        if not Meteor.user().curriculumIsSet()
          Router.go "selectCurriculum"

        if Meteor.isCordova and not Meteor.user().contentLoaded()

          Meteor.call 'contentEndpoint', (err, endpoint)->
            console.log "METEOR USER CURRICULUM", Meteor.user().getCurriculum()
            downloader = new ContentInterface(Meteor.user().getCurriculum(), endpoint)
            onSuccess = (entry)->
              Meteor.user().setContentAsLoaded true

            onError = (err)->
              alert "There was an error downloading your content, please log in and try again: ", err
              Meteor.user().setContentAsLoaded false
              Meteor.logout()
            downloader.loadContent(onSuccess, onError)
        else
          if Meteor.isCordova
            setCordovaContentSrc()
          else Meteor.call "contentEndpoint", (err, src)->
            console.log "Just set the content src", src
            Session.set "content src", src

        this.next()

    data: ()->
      if this.ready() and Meteor.user()
        curr = Curriculum.findOne({_id: Meteor.user().profile.curriculumId})
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

setCordovaContentSrc = ()->
  window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->
    console.log "Requested the local file system: ", fs
    root = fs.root.toURL()
    reader = fs.root.createReader()
    success = (entries)->
      console.log 'success'
      console.log entries
    fail = (err)->
      console.log 'err'
      console.log err
    reader.readEntries success, fail
    console.log "Setting the content src to ", root
    Session.set "content src", root
              
