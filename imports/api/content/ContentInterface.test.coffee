
### --------------------------- IMPORTS ------------------------------------- ###

{ ContentInterface } = require './ContentInterface.coffee'
{ OfflineFiles } = require 'meteor/noorahealth:mongo-schemas'
{ Factory } = require 'meteor/dburles:factory'
{ sinon } = require 'meteor/practicalmeteor:sinon'
should = require( 'chai' ).should()

### --------------------------- TESTS ------------------------------------- ###

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

  it "should source from endpoint when in browser", ->
    Meteor.isCordova = false
    fakeEndpoint = 'fake/endpoint/'
    sinon.stub ContentInterface.get(), 'getEndpoint', (path)-> fakeEndpoint + path
    should.exist ContentInterface.get().getSrc
    should.exist ContentInterface.get().getSrc()
    should.equal ContentInterface.get().getSrc('file'), fakeEndpoint + 'file'

  it 'should return empty string when in Cordova and not downloaded', ->
    Meteor.isCordova = true
    should.equal ContentInterface.get().getSrc('file'), ''

  # To be completed once it is possible to simulate the Cordova environment
  # 
  #it 'should source locally when in Cordova and file downloaded', ->
    #window.WebAppLocalServer = {
      #'localFileSystemUrl': ()->
    #}

    #sinon.stub WebAppLocalServer, 'localFileSystemUrl', (path) -> "local/path/" + path

    #Factory.define 'file', OfflineFiles, {
      #fsPath: 'local/file/path'
      #url: ContentInterface.get().getEndpoint 'filename'
      #name: 'filename'
    #}

    #file = Factory.create 'file'
    #console.log "FACTORY FILE"
    #console.log file
    #Meteor.isCordova = true
    
    #should.exist ContentInterface.get().getSrc(file.name)
    #should.not.equal ContentInterface.get().getSrc(file.name), ""
    #should.equal ContentInterface.get().getSrc(file.name), WebAppLocalServer.localFileSystemUrl file.fsPath

