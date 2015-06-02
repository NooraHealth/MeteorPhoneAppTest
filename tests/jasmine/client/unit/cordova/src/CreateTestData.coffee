class CreateTestData
  modules = []
  lessons = []
  curriculums = []
  curriculumTitle = 'Test Curriculum'
  lessonTitles = ['lesson1title', 'lesson2title']

  constructor: ()->
  
  setUp: ()->
    if Curriculum.find {title: @.curriculumTitle}
      return

    id1 = Modules.insert {
      'nh_id':'lesson1module1',
      'type':'MULTIPLE_CHOICE',
      'image':'NooraHealthContent/Image/actgoalsO1Q2.png',
      'options': [
        'NooraHealthContent/Image/actgoalsO1Q3.png',
        'NooraHealthContent/Image/actgoalsO3Q1.png',
        'NooraHealthContent/Image/actgoalsO3Q2.png',
        'NooraHealthContent/Image/actgoalsO3Q3.png',
        'NooraHealthContent/Image/actgoalsO4Q1.png',
        'NooraHealthContent/Image/actgoalsO4Q2.png'
      ],
      'audio': 'NooraHealthContent/Image/actgoalsO4Q3.png',
      'correct_audio':'NooraHealthContent/Image/actgoalsO5Q1.png',
      'incorrect_audio':'NooraHealthContent/Image/actgoalsO5Q2.png'
    }

    id2 = Modules.insert {
      'nh_id':'lesson1module2',
      'type':'SLIDE',
      'image':'NooraHealthContent/Image/actgoalsO5Q3.png',
      'audio':'NooraHealthContent/Image/actgoalsO6Q1.png'
    }

    lessonId1 = Lessons.insert {
      'title': lessonTitles[0],
      'nh_id':'testlesson1',
      'image':'NooraHealthContent/Image/actgoalsO1Q1.png',
      'modules':[id1, id2]
    }

    id3 = Modules.insert {
      'nh_id': 'lesson2module1',
      'type':'VIDEO',
      'video':'NooraHealthContent/Image/actgoalsO6Q2.png'
    }

    id4 = Modules.insert {
      'nh_id':lessonTitles[1],
      'type':'BINARY',
      'options':[ 'NO', 'YES'],
      'image':'NooraHealthContent/Image/actgoalsO6Q3.png'
    }

    lessonId2 = Lessons.insert {
      'title':'testlesson2',
      'nh_id':'testlesson2',
      'image':'NooraHealthContent/Image/actgoalsO2Q2.png',
      'modules':[id3, id4]
    }

    curriculumId1 = Curriculum.insert {
      'title':@.curriculumTitle,
      'condition':'Testing Condition',
      'lessons':['testlesson1', 'testlesson2'],
      'nh_id':'testcurriculum'
    }

    @.modules = [id1, id2, id3, id4]
    @.lessons = [lessonId1, lessonId2]
    @.curriculums = [curriculumId1]

  curriculumTitle: ()->
    return @.curriculumTitle

  lessonTitle: (i)->
    return @.lessonTitles[i]
  tearDown: ()->
    console.log "Tearing down the test data"
    console.log modules
    console.log lessons
    console.log curriculums
    for id in modules
      console.log "Removing module"
      Modules.remove {_id: id}

    for id in lessons modules
      console.log "Removing lesson"
      Lessons.remove {_id:id}

    for id in curriculums
      console.log "Removing curriculum"
      Curriculum.remove {_id: id}

