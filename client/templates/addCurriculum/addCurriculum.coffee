
Template.addModuleModal.helpers {
  option: (index)->
    return {option: index}
}


Template.createCurriculum.events {
  "click #addLesson":(event, template) ->
    $("#addLessonModal").openModal()

  "click #submitLesson": (event, template)->
    title =  $("#lessonTitle").val()
    shortTitle = $("#lessonShortTitle").val()
    tags = $("#lessonTags").val().split()
    lessonImage = $("#lessonImage")[0].files[0]

    prefix = Meteor.filePrefix lessonImage
    
    _id = Lessons.insert {
      title: title
      short_title: shortTitle
      tags: tags
      image: prefix
    }

    lesson = Lessons.update {_id: _id}, {$set: {nh_id: _id}}

    console.log Lessons.findOne {_id: _id}
    $("#lessonsList").append "<li name='lesson' id='#{_id}'>
      <div class='collapsible-header'>
      #{title}  
      <a style='float:right' class='waves-effect waves-blue right-align btn-flat' name='addModule'><i class='mdi-content-add'></i></a>
      </div>
      <div class='collapsible-body'><ul class='collection' id='moduleList#{_id}'></ul></div></li>"

    $(".collapsible").collapsible {
      accordion:false
      expandable:true
    }
    resetUploadSessions()

  "click [name^=addModule]": (event, template) ->
    id = $(event.target).closest("li").attr 'id'
    $("#moduleLessonId").attr "value", id
    Session.set "current editing lesson", id
    $("#moduleInitialization")[0].reset()
    $("#moduleAttributes")[0].reset()
    $("#addModuleModal").openModal()

  "change #moduleType": (event, template) ->
    type = $(event.target).val()
    $("#moduleAttributes")[0].reset()
    rows = $("#addModuleModal").find("div[name=attributeRow]")
    $.each(rows, (index, row)->
      if $(row).hasClass type
        $(row).slideDown()
      else
        $(row).slideUp()
    )

  "click #submitModule": (event, template)->
  
    question = $("#moduleQuestion").val()
    title=$("#moduleTitle").val()
    tags = $("#moduleTags").val().split()
    type= $("#moduleType").val()
   
    audio = if Session.get "audio" then Session.get("audio").path
    correctAudio = if Session.get "correct audio" then Session.get("correct audio").path
    incorrectAudio = if Session.get "incorrect audio" then Session.get("incorrect audio").path
    image = if Session.get "module image" then Session.get("module image").path
    video = if Session.get "module video" then Session.get("module video").path
    options = Session.get "module options"

    if !type
      alert "please identify a module type"
      return
    
    if type=="SCENARIO"
      correctOptions = [$("input[name=scenario_answer]:checked").val()]
      options = ["Normal" , "Call Doc", "Call 911"]

    if type=="BINARY"
      correctOptions=  [$("input[name=binary_answer]:checked").val()]
      options = ["Yes", "No"]

    if type=="MULTIPLE_CHOICE" || type=="GOAL_CHOICE"
      optionImages = (option.path for option in options)
      correctOptions =( optionImages[$(option).attr "id"] for option in $("input[name=option]:checked"))

    _id = Modules.insert {
      type:type
      correct_answer: correctOptions
      title:title
      question:question
      tags: tags
      options:optionImages
      video: video
      image: image
      audio: audio
      correct_audio: correctAudio
      incorrect_audio: incorrectAudio
    }
    console.log Modules.findOne {_id: _id}

    lessonId = Session.get "current editing lesson"
    $("#moduleList"+ Session.get "current editing lesson").append "<li class='collection-item' id='#{_id}' name='moduleof#{lessonId}'>#{title}#{question}</li>"
    resetUploadSessions()

  "click #submitCurriculum": (event, template) ->
    title = $("#curriculumTitle").val()
    if !title
      alert "Please identify a title for your curriculum"
      return
    condition = $("#condition").val()
    if !condition
      alert "Please identify a condition for your curriculum"
      return

    lessons = $("li[name=lesson]")
    $.each lessons, (index, lesson)->
      lessonId = $(lesson).attr 'id'
      modules = $("li[name=moduleof"+lessonId)
      moduleIds = ( $(module).attr 'id' for module in modules)
      lessonDoc = Lessons.update {_id: lessonId}, {$set:{modules: moduleIds}}
    
    lessonIds = ($(lesson).attr "id" for lesson in lessons)

    _id = Curriculum.insert {
      title:title
      lessons: lessonIds
      condition: condition
    }

    Curriculum.update {_id: _id}, {$set: {nh_id:_id}}
    alert("AYAYYYY!! new curriculum created")
    Router.go "home"
}

Template.addModuleModal.events {
  "click .optionCheckbox": (event, template)->
    box = $(event.target).closest(".uploadOption").find("input[type=checkbox]")
    if box.is ":checked"
      box.prop "checked", false
    else
      box.prop "checked", true
}

Template.createCurriculum.onRendered ()->
  $("select").material_select()

resetUploadSessions = ()->
  Session.set "module options", null
  Session.set "audio", null
  Session.set "correct audio", null
  Session.set "module video", null
  Session.set "incorrect audio", null
  Session.set "module image", null
  Session.get "current uploaded lesson image", null
  Session.set "module image", null
