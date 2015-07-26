if Meteor.isCordova
  return
describe "Users collection", ()->
  user = undefined
  beforeAll ()->
    id = Accounts.createUser {
      email: 'lucy@loo.com',
      password: 'lucytest',
      username:'lucy'
    }
    console.log "This is the userId: ", id
    
  it "should have a Meteor.user()", ()->
    expect(Meteor.user()).toBeDefined()
  #it "should have a helper function called setCurriculum", ()->
    #expect(Meteor.user().setCurriculum).toBeDefined()
  #it "should have a helper function called getCurriculum", ()->
    #expect(Meteor.user().getCurriculum).toBeDefined()
  #it "should have a helper function called curriculumIsSet", ()->
    #expect(Meteor.user().curriculumIsSet).toBeDefined()
  #it "should have a helper function called setContentAsLoaded", ()->
    #expect(Meteor.user().setContentAsLoaded).toBeDefined()
  #it "should have a helper function called contentLoaded", ()->
    #expect(Meteor.user().contentLoaded).toBeDefined()

