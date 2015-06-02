describe "ContentDownloader", ()->

  dataCreator =undefined
  downloader = undefined

  beforeAll ()->
    dataCreator = new CreateTestData()
    testCurriculum = Curriculum.findOne {title: dataCreator.curriculumTitle()}
    downloader = new ContentDownloader(testCurriculum)
    dataCreator.setUp()

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

    id2 = dataCreator.lessonId(1)
    lesson2 = Lessons.findOne {_id:id2}
    urls2 = downloader.retrieveContentUrls lesson2

    expect(urls2.length).toEqual 3
    
   
  it "should return an error when given invalid arguments", ()->
    expect(()-> downloader.retrieveContentUrls()).toThrow()
    expect(()-> downloader.retrieveContentUrls("a string")).toThrow()

  it 'should have a function called downloadFiles', ()->
    expect(downloader.downloadFiles).toBeDefined()


