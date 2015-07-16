Template.multipleChoiceModule.helpers
  secondRow: ()->
    return MultipleChoiceSurface.getOptions @, 3, 6
  firstRow: ()->
    return MultipleChoiceSurface.getOptions @, 0, 3
  module: ()->
    return @


