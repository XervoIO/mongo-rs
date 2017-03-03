const Prompt = require('prompt')

const versions = ['3.0.1', '3.0.2', '3.0.3', '3.2.0', '3.4.0', '3.4.2']
const ipMessage = 'This is used for replica set configuration'

module.exports = {
  properties: {
    enable: {
      description: 'Create mongo container?',
      message: 'Enter true or false',
      required: true,
      type: 'boolean'
    },
    install: {
      ask: () => Prompt.history('enable').value === true,
      description: 'Enter install name',
      required: true,
      type: 'string'
    },
    ip: {
      ask: () => Prompt.history('enable').value === true,
      description: `Enter host ip or dns name (${ipMessage})`,
      required: true,
      type: 'string'
    },
    version: {
      ask: () => Prompt.history('enable').value === true,
      conform: (value) => versions.indexOf(value) !== -1,
      description: 'Enter a mongo version',
      message: `Supported mongo versions (${versions.join(', ')})`,
      required: true
    },
    username: {
      ask: () => Prompt.history('enable').value === true,
      description: 'Enter mongo host admin username',
      required: true
    },
    password: {
      ask: () => Prompt.history('enable').value === true,
      description: 'Enter mongo host admin password',
      hidden: true,
      replace: '*',
      required: true
    }
  }
}
