if Meteor.isCordova
  return

describe "ContentDownloader", ()->

  dataCreator =undefined
  downloader = undefined

  beforeAll ()->
    dataCreator = new CreateTestData()
    testCurriculum = Curriculum.findOne {title: dataCreator.curriculumTitle()}
    dataCreator.setUp()

    downloader = new ContentDownloader(testCurriculum)

  afterAll ()->
    dataCreator.tearDown()
  
  it "should exist", ()->
    expect(dataCreator).toBeDefined()
    expect(downloader).toBeDefined()
    expect(ContentDownloader).toBeDefined()

  it "should return the correct url array when retrieveContentUrls is called", ()->
    id = dataCreator.lessonId(0)
    lesson = Lessons.findOne {_id: id}
    urls = downloader.retrieveContentUrls(lesson)

    expect(urls.length).toEqual 13
    expect('NooraHealthContent/Image/actgoalsO6Q1.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO1Q1.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO1Q2.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO1Q3.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO3Q1.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO3Q2.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO3Q3.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO4Q1.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO4Q2.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO4Q3.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO5Q1.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO5Q2.png' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO5Q3.png' in urls).toBeTruthy()

    id2 = dataCreator.lessonId(1)
    lesson2 = Lessons.findOne {_id:id2}
    urls2 = downloader.retrieveContentUrls lesson2

    expect(urls2.length).toEqual 3
    
   
  it "should return an error when given invalid arguments", ()->
    expect(()-> downloader.retrieveContentUrls()).toThrow()
    expect(()-> downloader.retrieveContentUrls("a string")).toThrow()

  it 'should have a function called downloadFiles', ()->
    expect(downloader.downloadFiles).toBeDefined()

describe "ParsedUrl", ()->

  beforeAll ()->
    dataCreator = new CreateTestData()
    dataCreator.setUp()

  afterAll ()->
    dataCreator.tearDown()

  it 'should have a class ParsedUrl', ()->
    expect(ParsedUrl).toBeDefined()
    console.log "ParsedUrl",  ParsedUrl
  it 'should have a function called directories', ()->
    expect(new ParsedUrl('string', 'string').directories).toBeDefined()
  it 'should have a function called file', ()->
    expect(new ParsedUrl('string', 'string').file).toBeDefined()
  it 'should have a function called endpointPath', ()->
    expect(new ParsedUrl('string', 'string').endpointPath).toBeDefined()
  it 'should give correct parsed directories for 2 dirs deep', ()->
    url = new ParsedUrl('NooraHealthContent/Image/file.txt', 'localhost:3000')
    directories= url.directories()
    expect(directories[0]).toEqual('NooraHealthContent')
    expect(directories[1]).toEqual('Image')
    expect(directories.length).toEqual 2

  it 'should give correct parsed directories for 4 dir deep', ()->
    url = new ParsedUrl('NooraHealthContent/Image/Dir/file.txt', 'localhost:3000')
    directories= url.directories()
    expect(directories[0] == 'NooraHealthContent').toBeTruthy()
    expect(directories[1] == 'Image').toBeTruthy()
    expect(directories[2] == 'Dir').toBeTruthy()
    expect(directories.length).toEqual 3

  it 'should give correct parsed directories for 1 dirs deep', ()->
    url = new ParsedUrl('Dir/file.txt', 'localhost:3000')
    directories= url.directories()
    expect(directories[0]).toEqual('Dir')
    expect(directories.length).toEqual 1

  it 'should give correct parsed directories for 0 dirs deep', ()->
    url = new ParsedUrl('file.txt', 'localhost:3000')
    directories= url.directories()
    expect(directories[0]).toBeUndefined()
    expect(directories.length).toEqual 0

class CreateTestData

  constructor: ()->
    @.modules = []
    @.lessons = []
    @.curriculums = []
    @.title = 'Test Curriculum'
    @.lessonTitles = ['lesson1title', 'lesson2title']
  
  setUp: ()->

    id1 = Modules.insert {
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
      'type':'SLIDE',
      'image':'NooraHealthContent/Image/actgoalsO5Q3.png',
      'audio':'NooraHealthContent/Image/actgoalsO6Q1.png'
    }

    lessonId1 = Lessons.insert {
      'title': @.lessonTitles[0],
      'image':'NooraHealthContent/Image/actgoalsO1Q1.png',
      'modules':[id1, id2]
    }

    id3 = Modules.insert {
      'type':'VIDEO',
      'video':'NooraHealthContent/Image/actgoalsO6Q2.png'
    }

    id4 = Modules.insert {
      'type':'BINARY',
      'options':[ 'NO', 'YES'],
      'image':'NooraHealthContent/Image/actgoalsO6Q3.png'
    }

    lessonId2 = Lessons.insert {
      'title':'testlesson2',
      'image':'NooraHealthContent/Image/actgoalsO2Q2.png',
      'modules':[id3, id4]
    }

    curriculumId1 = Curriculum.insert {
      'title':@.title,
      'condition':'Testing Condition',
      'lessons':['testlesson1', 'testlesson2'],
    }

    @.modules = [id1, id2, id3, id4]
    @.lessons = [lessonId1, lessonId2]
    @.curriculums = [curriculumId1]

  curriculumTitle: ()->
    return @.title

  lessonId: (i)->
    return @.lessons[i]

  tearDown: ()->
    for id in @.modules
      Modules.remove {_id: id}

    for id in @.lessons
      Lessons.remove {_id:id}

    for id in @curriculums
      Curriculum.remove {title: @.title}

