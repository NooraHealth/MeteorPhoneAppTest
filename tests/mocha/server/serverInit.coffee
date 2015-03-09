if typeof MochaWeb isnt 'undefined'
  MochaWeb.testOnly () ->
    describe "Server initialization", () ->
      it "should have a Meteor version defined", ()->
        chai.assert Meteor.release

      it "should have all collections defined", ()->
        chai.assert Curriculum
        chai.assert Modules
        chai.assert PreviousJson
        chai.assert Lessons
        chai.assert Attempts


