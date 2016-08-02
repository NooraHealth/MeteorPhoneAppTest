
#### --------------------------- IMPORTS ------------------------------------- ###

#{ ContentInterface } = require './ContentInterface.coffee'
#{ OfflineFiles } = require 'meteor/noorahealth:mongo-schemas'
#{ Factory } = require 'meteor/dburles:factory'
#{ sinon } = require 'meteor/practicalmeteor:sinon'
#should = require( 'chai' ).should()
#expect = require( 'chai' ).expect()

#### --------------------------- TESTS ------------------------------------- ###

#describe "ContentInterface", ->

  #it 'Should be a singleton', ->
    #should.exist ContentInterface.get

  #it "should know where app intro is", ->
    #should.exist ContentInterface.get().introPath
    #should.exist ContentInterface.get().introPath()
    #should.not.equal ContentInterface.get().introPath(), ""
    #should.equal ContentInterface.get().introPath(), "NooraHealthContent/Audio/AppIntro.mp3"

  #it "should know where correct soundeffect is", ->
    #should.exist ContentInterface.get().correctSoundEffectFilePath
    #should.exist ContentInterface.get().correctSoundEffectFilePath()
    #should.not.equal ContentInterface.get().correctSoundEffectFilePath(), ""
    #should.equal ContentInterface.get().correctSoundEffectFilePath(), "NooraHealthContent/Audio/correct_soundeffect.mp3"

  #it "should know where incorrect soundeffect is", ->
    #should.exist ContentInterface.get().incorrectSoundEffectFilePath
    #should.exist ContentInterface.get().incorrectSoundEffectFilePath()
    #should.not.equal ContentInterface.get().incorrectSoundEffectFilePath(), ""
    #should.equal ContentInterface.get().incorrectSoundEffectFilePath(), "NooraHealthContent/Audio/incorrect_soundeffect.mp3"

#describe "ContentInterface.get().getSrc", ->

  #it 'should return empty string when in Cordova and not downloaded', ->
    #Meteor.isCordova = true
    #should.equal ContentInterface.get().getSrc('file'), ''

#describe "ContentInterface.get().getEndpoint", ->

  #it "should have a function called getEndpoint", ->
    #should.exist ContentInterface.get().getEndpoint

  #it 'should throw an error when the first argument is not a string', ->
    #Meteor.isCordova = true
    #fn = ()->
      #ContentInterface.get().getEndpoint(()-> console.log "First Arg is a Function", "VIDEO")
    #(fn).should.throw(Error)

  #it 'should throw an error when the second argument is not VIDEO, AUDIO, or IMAGE', ->
    #Meteor.isCordova = true
    #(ContentInterface.get().getEndpoint.bind(this, "file.png", "VDIO")).should.throw(Error)
    #(ContentInterface.get().getEndpoint.bind(this, "file.png", "IMG")).should.throw(Error)
    #(ContentInterface.get().getEndpoint.bind(this, "file.png", ()-> console.log "A function")).should.throw(Error)
    #(ContentInterface.get().getEndpoint.bind("file.png", "False argument")).should.throw(Error)

  #it 'should not throw an error when the second argument is VIDEO, AUDIO, or IMAGE', ->
    #(ContentInterface.get().getEndpoint.bind(this, 'file.png', "VIDEO")).should.not.throw(Error)
    #(ContentInterface.get().getEndpoint.bind(this, 'file.png', "IMAGE")).should.not.throw(Error)
    #(ContentInterface.get().getEndpoint.bind(this, 'file.png', "AUDIO")).should.not.throw(Error)

  #it 'should return paths correctly when file is audio', ->
    #Meteor.isCordova = true
    #should.equal ContentInterface.get().getEndpoint('file.png', "AUDIO"), Meteor.settings.public.CONTENT_SRC + 'NooraHealthContent/Audio/file.png'
    #should.equal ContentInterface.get().getEndpoint('audiofile.mp3', "AUDIO"), Meteor.settings.public.CONTENT_SRC + 'NooraHealthContent/Audio/audiofile.mp3'

  #it 'should return paths correctly when file is image', ->
    #Meteor.isCordova = true
    #should.equal ContentInterface.get().getEndpoint('file.mp3', "IMAGE"), Meteor.settings.public.CONTENT_SRC + 'NooraHealthContent/Image/file.mp3'
    #should.equal ContentInterface.get().getEndpoint('imagefile.png', "IMAGE"), Meteor.settings.public.CONTENT_SRC + 'NooraHealthContent/Image/imagefile.png'

  #it 'should return paths correctly when file is video', ->
    #Meteor.isCordova = true
    #should.equal ContentInterface.get().getEndpoint('file.png', "VIDEO"), Meteor.settings.public.CONTENT_SRC + 'NooraHealthContent/Video/file.png'
    #should.equal ContentInterface.get().getEndpoint('videofile.mp4', "VIDEO"), Meteor.settings.public.CONTENT_SRC + 'NooraHealthContent/Video/videofile.mp4'

  ## To be completed once it is possible to simulate the Cordova environment
  ## 
  ##it 'should source locally when in Cordova and file downloaded', ->
    ##window.WebAppLocalServer = {
      ##'localFileSystemUrl': ()->
    ##}

    ##sinon.stub WebAppLocalServer, 'localFileSystemUrl', (path) -> "local/path/" + path

    ##Factory.define 'file', OfflineFiles, {
      ##fsPath: 'local/file/path'
      ##url: ContentInterface.get().getEndpoint 'filename'
      ##name: 'filename'
    ##}

    ##file = Factory.create 'file'
    ##console.log "FACTORY FILE"
    ##console.log file
    ##Meteor.isCordova = true
    
    ##should.exist ContentInterface.get().getSrc(file.name)
    ##should.not.equal ContentInterface.get().getSrc(file.name), ""
    ##should.equal ContentInterface.get().getSrc(file.name), WebAppLocalServer.localFileSystemUrl file.fsPath

