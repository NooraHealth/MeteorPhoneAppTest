Template.createCurriculum.events {
  "click #addLesson":(event, target) ->
    $("#addLessonModal").openModal()

  "click #submitLesson": (event, target)->
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
      <div class='collapsible-body'></div></li>"

    $(".collapsible").collapsible {
      accordion:false
      expandable:true
    }

  "click [name^=addModule]": (event, target) ->
    console.log "add module clicked"
    console.log event.target
    console.log $(event.target).closest "a"
    id = $(event.target).closest("a").attr 'id'
    console.log id
}

