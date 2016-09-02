
{ AppState } = require "../../AppState.coffee"

class FooterModel
  contructor: ( options ) ->

    new SimpleSchema({
      "homeButton.$.text": { type: String }
      "homeButton.$.visible": { type: String }
      "homeButton.$.animated": { type: String }
      "nextButton.$.text": { type: String }
      "nextButton.$.visible": { type: String }
      "nextButton.$.animated": { type: String }
      "replayButton.$.text": { type: String }
      "replayButton.$.visible": { type: String }
      "replayButton.$.animated": { type: String }
    }).validate options

    @state = new ReactiveDict()
    @state.set options

  set: ( option ) ->
    @state.set option

  get: ( option ) ->
    @state.get option

module.exports.FooterModel = FooterModel
