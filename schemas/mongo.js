const versions = ['3.0.1', '3.0.2', '3.0.3', '3.2.0', '3.4.0', '3.4.2']
const ipMessage = 'This is used for replica set configuration'

module.exports = {
  properties: {
    install: {
      description: 'Enter install name',
      required: true,
      type: 'string'
    },
    ip: {
      description: `Enter host ip or dns name (${ipMessage})`,
      required: true,
      type: 'string'
    },
    version: {
      conform: (value) => versions.indexOf(value) !== -1,
      description: 'Enter a mongo version',
      message: `Supported mongo versions (${versions.join(', ')})`,
      required: true
    },
    username: {
      description: 'Enter mongo host admin username',
      required: true
    },
    password: {
      description: 'Enter mongo host admin password',
      hidden: true,
      replace: '*',
      required: true
    }
  }
}
