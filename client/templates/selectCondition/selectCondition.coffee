Template.selectCondition.helpers {
  curriculums: ()->
    console.log "gettin ght curricula"
    console.log Curriculum.find({})
    return Curriculum.find({})
}
