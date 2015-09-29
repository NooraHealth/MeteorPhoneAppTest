
Meteor.startup ()->
  Meteor.subscribe "all", {
    onReady: ()->
      #endpoint = 'http://noorahealthcontent.noorahealth.org/'
      console.log "In Meteor.startup"
      endpoint = "http://noorahealthcontent.noorahealth.org.s3-website-us-west-1.amazonaws.com/"
      if Meteor.isCordova
        Scene.get().setContentSrc CordovaFileServer.httpUrl
      else
        Scene.get().setContentSrc endpoint
      Scene.get().setContentEndpoint endpoint
  }


