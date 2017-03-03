const Prompt = require('prompt')

module.exports = {
  properties: {
    enable: {
      description: 'Enable mongo backups?',
      message: 'Enter true or false',
      type: 'boolean',
      required: true
    },
    s3AccessKey: {
      ask: () => Prompt.history('enable').value === true,
      description: 'Enter AWS S3 access key',
      required: true
    },
    s3SecretKey: {
      ask: () => Prompt.history('enable').value === true,
      description: 'Enter AWS S3 secret key',
      required: true
    },
    s3Bucket: {
      ask: () => Prompt.history('enable').value === true,
      description: 'Enter AWS S3 bucket (folder path included)',
      message: 'Example bucket (mongo.backups/example-folder)',
      required: true
    }
  }
}
