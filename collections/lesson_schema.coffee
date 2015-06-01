###
# Lesson
#
# A lesson is a collection of modules, and may or 
# may not contain sublessons
###

LessonSchema = new SimpleSchema
  title:
    type:String
  description:
    type:String
    optional:true
  image:
    type: String
    #regEx:  /^([/]?\w+)+[.]png/
    optional:true
  tags:
    type:[String]
    minCount:0
    optional:true
  modules:
    type: [String]
    optional:true
  nh_id:
    type:String
    optional: true
    min:0

Lessons.attachSchema LessonSchema

Lessons.helpers {
  imgSrc: ()->
    console.log getMediaUrl()
    console.log getMediaUrl() + @.image
    url =getMediaUrl()
    return url + @.image

  getSublessonDocuments: ()->
    if !this.has_sublessons
      return []

    lessonDocuments = []
    _.each this.lessons, (lessonID) ->
      lesson = Lessons.findOne {nh_id: lessonID}
      if lesson?
        lessonDocuments.push lesson

    return lessonDocuments

  getModulesSequence: ()->
    if this.modules
      moduleDocs = (Modules.findOne {_id: moduleId} for moduleId in @.modules)
      return moduleDocs

    else
      modules = []
      module = @.getFirstModule()
      modules.push module
      until module.isLastModule()
        module = module.nextModule()
        modules.push module
      return modules

  getFirstModule: ()->
    return Modules.findOne {nh_id: @.first_module}

  hasSublessons: ()->
    if @.has_sublessons
      return @.has_sublessons == 'true'
    else
      return false


}

getMediaUrl = ()->
  if Meteor.isClient
    if Session.get "media url"
      return Session.get "media url"
    else
      return ""
  if Meteor.isServer or Meteor.isCordova
    return Meteor.call "mediaUrl"

