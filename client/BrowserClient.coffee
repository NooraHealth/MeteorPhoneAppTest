
class @BrowserClient extends Base
  
  #in a new cordova client, first initialize the server
  constructor: ()->
    super()
    console.log "Initializing the BrowserClient"
    @.contentSrc =  "http://noorahealthcontent.s3-us-west-1.amazonaws.com/"

  getContentSrc: ()=>
    return @.contentSrc

