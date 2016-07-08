
class BonusVideoPopup

  pitches: [
    { text: "Soon you will be an expert in caring for your condition!" },
    { text: "This knowledge will help prevent complications" },
    { text: "You are on your way to better health!" },
    { text: "Soon you will be able to care for your condition with confidence" }
  ]

  aFewWrong: "It looks like you got a few wrong."

  question: "Would you like to learn more by watching a bonus video?"

  constructor: ()->

  display: ( onConfirm, onCancel, aFewWrong )=>
    rand = Math.random() * ( @pitches.length)
    pitch = @pitches[Math.floor(rand)].text
    confirmButtonText = "Watch Video"
    text = ""
    if aFewWrong
      text += @aFewWrong
    text += " #{@question}"
    swal({
      title: pitch
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

