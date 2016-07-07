
class BonusVideoPopup

  pitches: [
    { text: "This app will give you the knowledge you need to care for your condition" },
    { text: "This app will help you feel confident in caring for your condition." },
    { text: "By learning these skills, you can help prevent complications" },
    { text: "This knowledge is essential to care for your condition properly" }
  ]

  aFewWrong: "Looks like you got a few wrong."

  mostlyCorrect: "Good job!"

  question: "Would you like to learn more by watching a bonus video?"

  constructor: ()->

  display: ( onConfirm, onCancel )=>
    confirmButtonText = "Watch Video"
    text = @pitches[0].text
    title = @aFewWrong + " " + @question
    swal({
      title: title
      text: text
      confirmButtonText: confirmButtonText
      cancelButtonText: "Go To Next Lesson"
      showCancelButton: true
      animation: "pop"
    }, ( isConfirm ) =>
      if isConfirm
        onConfirm?()
      else
        onCancel?()
    )
  

module.exports.BonusVideoPopup = BonusVideoPopup

