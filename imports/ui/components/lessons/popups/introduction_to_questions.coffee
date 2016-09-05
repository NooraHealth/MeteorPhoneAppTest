
{ Translator } = require('../../../../api/utilities/Translator.coffee')

class IntroductionToQuestions

  constructor: ()->

  send: ( onConfirm, onCancel, language)=>
    title = Translator.translate "great", language
    text = Translator.translate "introduce_questions", language

    console.log "Allow outside click??"
    swal({
      title: title
      text: text
      confirmButtonText: Translator.translate "ok", language
      animation: "slide-from-bottom"
      allowEscapeKey: false
      allowOutsideClick: false
    }, ( isConfirm ) =>
      if isConfirm
        onConfirm?()
      else
        onCancel?()
    )
  
module.exports.IntroductionToQuestions = IntroductionToQuestions

