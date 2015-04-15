this.completedChapter = (nh_id)->
  index = Session.get "current chapter index"
  chapters = (chapter.nh_id for chapter in Session.get "chapters sequence")
  if _.indexOf(chapters, nh_id) < index
    console.log "TRUEE"
    return true
  else
    return false

