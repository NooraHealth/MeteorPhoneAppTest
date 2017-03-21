module.exports = {
  servers: {
    one: {
      "host": "54.153.84.163",
      "username": "ubuntu",
      "pem" : "/Users/artichokes/Documents/NooraHealth/configuration-files/asus.pem"
    }
  },

  meteor: {
    name: 'TrainingApp',
    path: '/Users/artichokes/Documents/NooraHealth/training-app',
    servers: {
      one: {}
    },
    buildOptions: {
      serverOnly: true,
      debug: true,
    },
    env: {
      "MONGO_URL": "mongodb://frankophile:artichokesfordinner@c312.lighthouse.2.mongolayer.com:10312,lighthouse.3.mongolayer.com:10311/webapp?replicaSet=set-555b94436b0733dec5001b44",
      "PORT": 80,
      "ROOT_URL": "http://trainingappstaging.noorahealth.org",
      "METEOR_ENV": "production"
    },

    dockerImage: 'abernix/meteord:base',
    deployCheckWaitTime: 60
  }
};
