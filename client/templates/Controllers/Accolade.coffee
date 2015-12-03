class @Accolade
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
    @.index = 0


  sendAccolade: ()->
    message = @.messages[@.index]
    swal({
      title: message.title
      imageUrl: message.image
      animation: "slide-from-bottom"
      timer: 5000
    })

    @.index = @.index++ % @.messages.length

      

