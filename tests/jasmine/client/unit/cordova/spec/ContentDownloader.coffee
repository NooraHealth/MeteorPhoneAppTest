describe "ContentDownloader", ()->
  downloader=undefined

  beforeAll ()->
    dataCreator = new CreateTestData()
    testCurriculum = Curriculum.findOne {title: dataCreator.curriculumTitle()}
    downloader = new ContentDownloader(testCurriculum)
    dataCreator.setUp()

    console.log "Getting the lesson count: "
    console.log Lessons.find({nh_id: 'testlesson1'}).count()
    console.log "Curriculums"
    console.log Curriculum.find({}).count()

  afterAll ()->
    dataCreator.tearDown()
  
  it "should exist", ()->
    expect(downloader).toBeDefined()
    expect(ContentDownloader).toBeDefined()

  it "should return the correct url array when retrieveContentUrls is called", ()->
    lesson = Lessons.findOne {nh_id: dataCreator.lessonTitle(0)}
    console.log "Lesson have .pong?", lesson
    urls = downloader.retrieveContentUrls(lesson)

    expect(urls.length).toEqual 13
    console.log urls
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

    lesson2 = Lessons.findOne {nh_id:dataCreator.lessonTitle(1)}
    urls2 = downloader.retrieveContentUrls lesson2

    console.log urls2
    expect(urls2.length).toEqual 3
    
   
  it "should return an error when given invalid arguments", ()->
    expect(()-> downloader.retrieveContentUrls()).toThrow()
    expect(()-> downloader.retrieveContentUrls("a string")).toThrow()

  it 'should have a function called downloadFiles', ()->
    expect(downloader.downloadFiles).toBeDefined()


