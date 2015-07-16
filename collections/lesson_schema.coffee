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
  icon:
    type: String
    #regEx:  /^([/]?\w+)+[.]png/
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
  first_module:
    type: String
  nh_id:
    type:String
    optional: true
    min:0

Lessons.attachSchema LessonSchema

Lessons.helpers {
  imgSrc: ()->
    url = Meteor.getContentSrc()
    console.log "This is the content src: "
    console.log url
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


