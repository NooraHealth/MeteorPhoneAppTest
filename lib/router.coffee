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

        console.log " -------------- HOME ROUTE ------------ "
        if not Meteor.user().curriculumIsSet()
          console.log "--------curriculum is set -----------"
          Router.go "selectCurriculum"

        if Meteor.isCordova and not Meteor.user().contentLoaded()
          console.log "IN ROUTER CORDOVA"
          Meteor.call 'contentEndpoint', (err, endpoint)->
            console.log "Meteor USER CURRICULUM", Meteor.user().getCurriculum()
            downloader = new ContentInterface(Meteor.user().getCurriculum(), endpoint)
            onSuccess = (entry)->
              Meteor.user().setContentAsLoaded true

            onError = (err)->
              alert "There was an error downloading your content, please log in and try again: ", err
              Meteor.user().setContentAsLoaded false
              Meteor.logout()
            downloader.loadContent(onSuccess, onError)

        else
          if !Meteor.isCordova
            Meteor.call "contentEndpoint", (err, src)->
              console.log "just set the content src", src
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

  this.route '/selectcurriculum', {
    path: '/selectcurriculum'
    layouttemplate: 'layout'
    name: 'selectcurriculum'
    yieldtemplates: {
      'selectcurriculumfooter': {to:"footer"}
    }
    onbeforeaction: ()->
      Session.set "current transition", "opacity"
      Meteor.subscribe "curriculums"
      this.next()
  }

  ###
  # module sequence
  ###
  this.route '/modules/:nh_id', {
    path: '/modules/:nh_id'
    layouttemplate: 'layout'
    name: 'modulessequence'
    template: "module"
    yieldtemplates: {
      'modulefooter': {to:"footer"}
    }
    onbeforeaction: ()->
      Session.set "current transition", "slidewindowright"
      this.next()
    data: () ->
      if this.ready()
        lesson = lessons.findOne {nh_id: this.params.nh_id}
        Session.set "current lesson", lesson
        modules = lesson.getmodulessequence()
        Session.set "modules sequence", modules
        Session.set "current module index",0
        Session.set "correctly answered", []
        Session.set "incorrectly answered", []
        Session.set "next button is hidden", false
        return {modules:  modules  }
        
  }


  ###
  # refresh the content
  ###
  this.route '/refreshcontent', {
    path: '/refreshcontent'
    data: ()->
      Meteor.call "refreshcontent", ()->
        console.log "Yey called refresh"
  }


Router.configure {
  progressSpinner:false

}

