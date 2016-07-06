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

  sendAward: ( onConfirm, onCancel )=>
    rand = Math.random() * ( @.messages.length)
    console.log "This is rand:"  + rand
    message = @.messages[Math.floor(rand)]
    swal({
      title: message.title
      imageUrl: message.image
      confirmButtonText: "Go To Next Lesson"
      cancelButtonText: "Finish"
      showCancelButton: true
      animation: "slide-from-bottom"
      timer: 5000
    }, ( isConfirm ) =>
      if isConfirm
        onConfirm()
      else
        onCancel()
    )
  

module.exports.Award = Award

