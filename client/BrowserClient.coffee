
class @BrowserClient extends Base
  
  #in a new cordova client, first initialize the server
  constructor: ()->
    super()
    @.contentSrc = "http://d3q6h1ss6edf0g.cloudfront.net/" #http://noorahealthcontent.s3-us-west-1.amazonaws.com/"

  getContentSrc: ()=>
    return @.contentSrc

