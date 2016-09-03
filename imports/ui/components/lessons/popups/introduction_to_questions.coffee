
{ Translator } = require('../../../../api/utilities/Translator.coffee')

class IntroductionToQuestions

  constructor: ()->

  send: ( onConfirm, onCancel, language)=>
    title = Translator.translate "great", language
    text = Translator.translate "introduce_questions", language

    swal({
      title: title
      text: text
      confirmButtonText: Translator.translate "ok", language
      animation: "slide-from-bottom"
    }, ( isConfirm ) =>
      if isConfirm
        onConfirm?()
      else
        onCancel?()
    )
  

module.exports.IntroductionToQuestions = IntroductionToQuestions

