class Award
  messages: [
    {
      image: "/accolade_1.gif",
      title: "Great job!"
    },
    {
      image: "/accolade_2.gif",
      title: "Nice one!"
    },
    {
      image: "/accolade_3.gif",
      title: "You're on your way to better health!"
    },
    {
      image: "/accolade_4.gif",
      title: "Well done!"
    },
    {
      image: "/accolade_4.gif",
      title: "Congratulations!"
    }
  ]

  constructor: ()->

  sendAward: ( onConfirm, onCancel , lessonsComplete, totalLessons )=>
    rand = Math.random() * ( @.messages.length)
    console.log "This is rand:"  + rand
    message = @.messages[Math.floor(rand)]
    endOfCurriculum = lessonsComplete == totalLessons
    confirmButtonText = if endOfCurriculum then "OK" else "NEXT LESSON"
    text = "You have completed #{lessonsComplete} out of #{totalLessons} lessons!"
    swal({
      title: message.title
      text: text
      imageUrl: message.image
      confirmButtonText: confirmButtonText
      cancelButtonText: "Finish"
      showCancelButton: !endOfCurriculum
      animation: "slide-from-bottom"
    }, ( isConfirm ) =>
      if isConfirm
        onConfirm?()
      else
        onCancel?()
    )
  

module.exports.Award = Award

