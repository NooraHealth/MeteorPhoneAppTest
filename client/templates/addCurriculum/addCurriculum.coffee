Template.createCurriculum.events {
  "click #addLesson":(event, template) ->
    $("#addLessonModal").openModal()

  "click #submitLesson": (event, template)->
    files = event.target.files
    title =  $("#lessonTitle").val()
    shortTitle = $("#lessonShortTitle").val()
    tags = $("#lessonTags").val().split()
    _id = Lessons.insert {
      title: title
      short_title: shortTitle
      tags: tags
    }

    lesson = Lessons.update {_id: _id}, {$set: {nh_id: _id}}

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
    options = []
    $.each $("input[name=option]"), (index, option) ->
      options.push $(option).val()

    question = $("#moduleQuestion").val()
    title=$("#moduleTitle").val()
    tags = $("#moduleTags").val().split()
    type= $("#moduleType").val()
    
    if !type
      alert "please identify a module type"
      return

    id = Modules.insert {
      type:type
      title:title
      question:question
      tags: tags
      options:options
    }

    lessonId = Session.get "current editing lesson"
    $("#moduleList"+ Session.get "current editing lesson").append "<li class='collection-item' id='#{id}' name='moduleof#{lessonId}'>#{title}#{question}</li>"

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
}

Template.createCurriculum.onRendered ()->
  $("select").material_select()
