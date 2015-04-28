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

    $("#lessonsList").append "<li>
      <div class='collapsible-header'>
      #{title}  
      <a style='float:right' class='waves-effect waves-blue right-align btn-flat' name='addModule' id='#{_id}'><i class='mdi-content-add'></i></a>
      </div>
      <div class='collapsible-body'><ul class='collection' id='moduleList#{_id}'></ul></div></li>"

    $(".collapsible").collapsible {
      accordion:false
      expandable:true
    }

  "click [name^=addModule]": (event, template) ->
    id = $(event.target).closest("a").attr 'id'
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
    
    id = Modules.insert {
      type:type
      title:title
      question:question
      tags: tags
      options:options
    }

    console.log "id! ", id
    lessonId = Session.get "current editing lesson"
    $("#moduleList"+ Session.get "current editing lesson").append "<li class='collection-item' id='#{id}' name='#{lessonId}'>#{title}#{question}</li>"

}

