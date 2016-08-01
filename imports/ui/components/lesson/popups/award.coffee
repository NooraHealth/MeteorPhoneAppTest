{ AppState } = require('../../../../api/AppState.coffee')

class Award
  messages: [
    {
      image: "/accolade_1.gif",
      title: "great_job"
    },
    {
      image: "/accolade_2.gif",
      title: "nice_one"
    },
    {
      image: "/accolade_3.gif",
      title: "on_your_way"
    },
    {
      image: "/accolade_4.gif",
      title: "well_done"
    },
    {
      image: "/accolade_4.gif",
      title: "congratulations"
    }
  ]

  constructor: (language)->
    @language = language

  sendAward: ( onConfirm, onCancel , lessonsComplete, totalLessons )=>
    console.log "The award language #{@language}"
    rand = Math.random() * ( @.messages.length)
    message = @.messages[Math.floor(rand)]
    endOfCurriculum = lessonsComplete == totalLessons
    confirmButtonText = if endOfCurriculum then AppState.translate "ok", @language, "UPPER" else AppState.translate "next_lesson", @language, "UPPER"
    text = AppState.translate "you_have_completed", @language, "", {
      postProcess: "sprintf" ,
      sprintf: [ lessonsComplete, totalLessons ]
    }

    swal({
      title: AppState.translate message.title, @language
      text: text
      imageUrl: message.image
      confirmButtonText: confirmButtonText
      cancelButtonText: AppState.translate "finish", @language, "UPPER"
      showCancelButton: !endOfCurriculum
      animation: "slide-from-bottom"
    }, ( isConfirm ) =>
      if isConfirm
        onConfirm?()
      else
        onCancel?()
    )
  

module.exports.Award = Award

