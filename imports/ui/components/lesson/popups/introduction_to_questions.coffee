{ AppState } = require('../../../../api/AppState.coffee')

class IntroductionToQuestions

  constructor: ()->

  send: ( onConfirm, onCancel, language)=>
    title = AppState.translate "great", language
    text = AppState.translate "introduce_questions", language

    swal({
      title: title
      text: text
      confirmButtonText: AppState.translate "ok", language
      animation: "slide-from-bottom"
    }, ( isConfirm ) =>
      if isConfirm
        onConfirm?()
      else
        onCancel?()
    )
  

module.exports.IntroductionToQuestions = IntroductionToQuestions

