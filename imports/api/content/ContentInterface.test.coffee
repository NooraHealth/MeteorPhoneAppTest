{ ContentInterface } = require './ContentInterface.coffee'
{ sinon } = require 'meteor/practicalmeteor:sinon'
should = require( 'chai' ).should()

describe "ContentInterface", ->

  it 'Should be a singleton', ->
    should.exist ContentInterface.get

  it "should know where app intro and sound effects are", ->
    should.exist ContentInterface.get().introPath
    should.exist ContentInterface.get().introPath()
    should.not.equal ContentInterface.get().introPath(), ""

    should.exist ContentInterface.get().correctSoundEffectFilePath
    should.exist ContentInterface.get().correctSoundEffectFilePath()
    should.not.equal ContentInterface.get().correctSoundEffectFilePath(), ""

    should.exist ContentInterface.get().incorrectSoundEffectFilePath
    should.exist ContentInterface.get().incorrectSoundEffectFilePath()
    should.not.equal ContentInterface.get().incorrectSoundEffectFilePath(), ""

  it "should know where content is stored remotely", ->
    should.exist ContentInterface.get().getEndpoint
    should.exist ContentInterface.get().getEndpoint()
    should.equal ContentInterface.get().getEndpoint(), Meteor.settings.public.CONTENT_SRC
    should.equal ContentInterface.get().getEndpoint("file"), Meteor.settings.public.CONTENT_SRC + "file"

  it "should know where to source content", ->
    fakeEndpoint = 'fake/endpoint/'
    sinon.stub ContentInterface.get(), 'getEndpoint', (path)-> fakeEndpoint + path
    should.exist ContentInterface.get().getSrc
    should.exist ContentInterface.get().getSrc()
    if not Meteor.isCordova
      should.equal ContentInterface.get().getSrc('file'), fakeEndpoint + 'file'

