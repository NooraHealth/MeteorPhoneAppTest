Template.home.helpers
  rowsOfLessonThumbnails: ()->
    lessons = Scene.get().getLessons()
    numPerRow = 2
    numRows = Math.ceil lessons.length / numPerRow
    row = 0
    rows = []
    while row < numRows
      index = numPerRow * row
      arr = lessons.slice index, index + numPerRow
      rows.push arr
    console.log "Here are the rows"
    return rows

