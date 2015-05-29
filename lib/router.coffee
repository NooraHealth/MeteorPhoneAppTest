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
        Session.set "current transition", "slideWindowRight"
        if not Meteor.user().profile
          Meteor.users.update {_id: Meteor.user()._id}, {$set: {"profile": {} }}
          Router.go "selectCurriculum"
        else if not Meteor.user().profile.curriculumId
          Router.go "selectCurriculum"

        if Meteor.isCordova and not Meteor.user().profile.content_loaded
          console.log "cordova!"
          Meteor.call "loadContent", (err, result)->
            if err
              alert "There was an error loading your content"
            else
              console.log "Result of loading content: ", result

        if not Meteor.user().profile.chapters_complete
          Meteor.users.update {_id: Meteor.user()._id}, {$set:{"profile.chapters_complete": []}}
        else
          Meteor.call "mediaUrl", (err, result) ->
            if err
              console.log "error retrieving mediaURL: ", err
            else
              console.log "SETTING the mediaUrl", result
              Session.set "media url", result
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
