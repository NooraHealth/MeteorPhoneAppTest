describe "ContentDownloader", ()->
  downloader=undefined

  beforeAll ()->
    testCurriculum = Curriculum.findOne {title: 'TestCurriculum'}
    downloader = new ContentDownloader(testCurriculum)
    dataCreator = new CreateTestData()
    dataCreator.reset()

    console.log "Getting the lesson count: "
    console.log Lessons.find({nh_id: 'testlesson1'}).count()
  
  it "should exist", ()->
    expect(downloader).toBeDefined()
    expect(ContentDownloader).toBeDefined()

  it "should return the correct url array when retrieveContentUrls is called", ()->
    lesson = Lessons.findOne {nh_id: 'testlesson1'}
    urls = downloader.retrieveContentUrls(lesson)

    expect(urls.length).toEqual 13
    expect('NooraHealthContent/Image/actgoalsO6Q1' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO1Q1' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO1Q2' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO1Q3' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO3Q1' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO3Q2' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO3Q3' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO4Q1' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO4Q2' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO4Q3' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO5Q1' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO5Q2' in urls).toBeTruthy()
    expect('NooraHealthContent/Image/actgoalsO5Q3' in urls).toBeTruthy()
   
  it "should return an error when given invalid arguments", ()->
    expect(()-> downloader.retrieveContentUrls()).toThrow()
    expect(()-> downloader.retrieveContentUrls("a string")).toThrow()
