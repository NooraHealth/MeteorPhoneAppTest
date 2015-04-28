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
      <div class='collapsible-body'><ul id='moduleList#{_id}'></ul></div></li>"

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
    $("#moduleList"+ Session.get "current editing lesson").append "<li>HELLO</li>" 
    
}

