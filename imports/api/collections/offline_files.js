
const OfflineFiles = new Ground.Collection( "offline_files", {connection: null} );

const OfflineFilesSchema = new SimpleSchema({
  fsPath: {
    type:String
  },
  filename: {
    type: String
  }
});

OfflineFiles.attachSchema( OfflineFilesSchema );

module.exports.OfflineFiles = OfflineFiles;
