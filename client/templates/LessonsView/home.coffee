Template.lessonsView.helpers
  rows: ()->
    lessons = Scene.get().getLessons()
    if not lessons
      return []
    numPerRow = 2
    numRows = Math.ceil lessons.length / numPerRow
    row = 0
    rows = []
    while row < numRows
      index = numPerRow * row
      arr = lessons.slice index, index + numPerRow
      rows.push {lessons: arr}
      row++
    return rows

