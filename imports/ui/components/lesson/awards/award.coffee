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

  sendAward: ( onConfirm, onCancel , endOfCurriculum )=>
    rand = Math.random() * ( @.messages.length)
    console.log "This is rand:"  + rand
    message = @.messages[Math.floor(rand)]
    confirmButtonText = if endOfCurriculum then "" else "NEXT LESSON"
    console.log "This this the confirm button text: #{confirmButtonText}"
    swal({
      title: message.title
      imageUrl: message.image
      confirmButtonText: confirmButtonText
      cancelButtonText: "Finish"
      showCancelButton: !endOfCurriculum
      animation: "slide-from-bottom"
      timer: 5000
    }, ( isConfirm ) =>
      if isConfirm
        console.log "On confirm"
        console.log onConfirm?
        onConfirm?()
      else
        console.log onCancel?
        onCancel?()
    )
  

module.exports.Award = Award

