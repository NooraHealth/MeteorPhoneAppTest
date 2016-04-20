
OfflineFiles = require('./offline_files.coffee').OfflineFiles

Array::merge = (other) -> Array::push.apply @, other

class @ContentDownloader

  @downloadFiles: (files) ->

    new SimpleSchema({
      "files.$.name": {type: String}
      "files.$.url": {type: String}
    }).validate({files: files})

    deferred = Q.defer()
    numToLoad = files.length
    numRecieved = 0

    window.requestFileSystem LocalFileSystem.PERSISTENT, 5*1024*1024, (fs)->

      ft = new FileTransfer()

      ft.onprogress = (event)->
        percent = numRecieved/numToLoad
        Session.set "percent loaded", percent

      downloadFile = (file) ->
        offlineId = Random.id()
        console.log fs
        console.log fs.root
        fsPath = fs.root.toUrl() + offlineId + file.name
        ft.download(file.url, fsPath, getSuccessCallback(file, fsPath), getErrorCallback(file, fsPath))

      getSuccessCallback = (file, fsPath) ->
        return (entry)->
          numRecieved++
          console.log "RESOLVED:" + numRecieved + "/"+ numToLoad
          console.log entry
          OfflineFiles.insert {
            url: file.url
            name: file.name
            fsPath: fsPath
          }
          if numRecieved == numToLoad
            deferred.resolve entry

      getErrorCallback = (file) ->
        return (error)->
          console.log "ERROR "
          console.log error
          if error.http_status == 404
            markAsResolved()
          else if error.code == 3
            downloadFile file
          else
            deferred.reject(error)

      for file in files
        if not (OfflineFiles.findOne { url: file.url })?
          downloadFile file

    , (err)->
      console.log "ERROR requesting local filesystem: "
      console.log err
      promise.reject err

    return deferred.promise

module.exports.ContentDownloader = ContentDownloader

