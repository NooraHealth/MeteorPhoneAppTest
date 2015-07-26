
class @BrowserClient extends Base
  
  #in a new cordova client, first initialize the server
  constructor: ()->
    super()
    @.contentSrc = "http://d1loll817ogoo0.cloudfront.net/" #"http://noorahealthcontent.s3-us-west-1.amazonaws.com/"

  getContentSrc: ()=>
    return @.contentSrc

