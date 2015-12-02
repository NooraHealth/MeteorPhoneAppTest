
Template.layout.helpers
  lessonTitle: ()->
    return Scene.get().getCurrentLesson().title

  module: ()->
    return FlowRouter.getParam "_id"

  subscriptionsReady: ()->
    lessonsReady = Template.instance().lessonsReady.get()
    currReady = Template.instance().currReady.get()
    modulesReady = Template.instance().modulesReady.get()
    console.log "Are the subscriptionsReady?"
    console.log lessonsReady and currReady and modulesReady
    return lessonsReady and currReady and modulesReady

Template.layout.onCreated ()->
  @.currReady = new ReactiveVar()
  @.lessonsReady = new ReactiveVar()
  @.modulesReady = new ReactiveVar()

  @.autorun ()=>
    console.log "Subscribing"
    curriculumId = Session.get "curriculum id"
    currHandle = Subs.subscribe "curriculums"
    lessonsHandle = Subs.subscribe "lessons", curriculumId
    modulesHandle = Subs.subscribe "modules_in_curriculum", curriculumId
    @.modulesReady.set modulesHandle.ready()
    @.currReady.set currHandle.ready()
    @.lessonsReady.set lessonsHandle.ready()

  @.autorun ()=>
    lessonsReady = @.lessonsReady.get()
    currReady = @.currReady.get()
    modulesReady = @.modulesReady.get()
    if lessonsReady and currReady and modulesReady
      console.log "Notifying that subscriptions are ready!"
      Scene.get().notifySubscriptionsReady()
    
Template.layout.events
  "click #logo": ()->
    FlowRouter.go "/"
