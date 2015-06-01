class CreateTestData
  constructor: ()->
    Meteor.call "clearMongo"

  
  reset: ()->
    id1 = Modules.insert {
      'nh_id':'lesson1module1',
      'type':'MULTIPLE_CHOICE',
      'image':'NooraHealthContent/Image/actgoalsO1Q2',
      'options': [
        'NooraHealthContent/Image/actgoalsO1Q3',
        'NooraHealthContent/Image/actgoalsO3Q1',
        'NooraHealthContent/Image/actgoalsO3Q2',
        'NooraHealthContent/Image/actgoalsO3Q3',
        'NooraHealthContent/Image/actgoalsO4Q1',
        'NooraHealthContent/Image/actgoalsO4Q2'
      ],
      'audio': 'NooraHealthContent/Image/actgoalsO4Q3',
      'correct_audio':'NooraHealthContent/Image/actgoalsO5Q1',
      'incorrect_audio':'NooraHealthContent/Image/actgoalsO5Q2'
    }

    id2 = Modules.insert {
      'nh_id':'lesson1module2',
      'type':'SLIDE',
      'image':'NooraHealthContent/Image/actgoalsO5Q3',
      'audio':'NooraHealthContent/Image/actgoalsO6Q1'
    }

    Lessons.insert {
      'title':'testlesson1',
      'nh_id':'testlesson1',
      'image':'NooraHealthContent/Image/actgoalsO1Q1',
      'modules':[id1, id2]
    }

    id3 = Modules.insert {
      'nh_id': 'lesson2module1',
      'type':'VIDEO',
      'video':'NooraHealthContent/Image/actgoalsO6Q2'
    }

    id4 = Modules.insert {
      'nh_id':'lesson2module2',
      'type':'BINARY',
      'options':[ 'NO', 'YES'],
      'image':'NooraHealthContent/Image/actgoalsO6Q3'
    }


    Lessons.insert {
      'title':'testlesson2',
      'nh_id':'testlesson2',
      'image':'NooraHealthContent/Image/actgoalsO2Q2.png',
      'modules':[id3, id4]
    }

    Curriculum.insert {
      'title':'Test',
      'condition':'Testing Condition',
      'lessons':['testlesson1', 'testlesson2'],
      'nh_id':'testcurriculum'
    }

