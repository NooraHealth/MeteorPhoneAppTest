Template.chapter.helpers
  imageURL: ()->
    if _.isEmpty(@)
      return ""
    else
      return MEDIA_URL+ @.image
    

Template.chapter.events
  "click .thumbnail" : (event, template)->
    console.log $(event.target).parent('a')



