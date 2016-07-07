
class BonusVideoPopup

  pitches: [
    { text: "This app will give you the knowledge you need to care for your condition" },
    { text: "This app will help you feel confident in caring for your condition." },
    { text: "By learning these skills, you can help prevent complications" },
    { text: "This knowledge is essential to care for your condition properly" }
  ]
  aFewWrong: "Looks like you got a few wrong"

  mostlyCorrect: "Good job!"

  question: "Would you like to learn more by watching a bonus video?"

  constructor: ()->

  displayPopup: ( onConfirm, onCancel , lessonsComplete, totalLessons )=>
    endOfCurriculum = lessonsComplete == totalLessons
    confirmButtonText = "Watch Video"
    text = "You have completed #{lessonsComplete} out of #{totalLessons} lessons!"
    swal({
      title: message.title
      text: text
      imageUrl: message.image
      confirmButtonText: confirmButtonText
      cancelButtonText: "Go To Next Lesson"
      showCancelButton: !endOfCurriculum
      animation: "slide-from-bottom"
    }, ( isConfirm ) =>
      if isConfirm
        onConfirm?()
      else
        onCancel?()
    )
  

module.exports.BonusVideoPopup = BonusVideoPopup

