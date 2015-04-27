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
      <a class='btn' name='addModule' id='#{_id}'><i class='mdi-content-action'></i></a>
      </div>
      <div class='collapsible-body'><p>BODY</p></div></li>"

    $(".collapsible").collapsible {
      accordion:false
      expandable:true
    }

  "click [name^=addModule]": (event, target) ->
    console.log "add module clicked"
}

