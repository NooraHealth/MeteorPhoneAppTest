


## TODO: hold progress in this as well
class FooterModel

  constructor: ( options, visible ) ->

    new SimpleSchema({
      "homeButton.text": { type: String }
      "homeButton.visible": { type: Boolean }
      "homeButton.animated": { type: Boolean }
      "homeButton.disabled": { type: Boolean }
      "nextButton.text": { type: String }
      "nextButton.visible": { type: Boolean }
      "nextButton.animated": { type: Boolean }
      "nextButton.disabled": { type: Boolean }
      "replayButton.text": { type: String }
      "replayButton.visible": { type: Boolean }
      "replayButton.animated": { type: Boolean }
      "replayButton.disabled": { type: Boolean }
      "bar.visible": { type: Boolean }
    }).validate options

    @state = {
      nextButton: new ReactiveDict()
      homeButton: new ReactiveDict()
      replayButton: new ReactiveDict()
      bar: new ReactiveDict()
    }

    @state.nextButton.set options.nextButton
    @state.replayButton.set options.replayButton
    @state.homeButton.set options.homeButton
    @state.bar.set options.bar

  set: ( component, option ) ->
    @state[component].set option

  get: ( component, option ) ->
    @state[component].get option

module.exports.FooterModel = FooterModel
