const Prompt = require('prompt')

module.exports = {
  properties: {
    enable: {
      description: 'Enable mongo metrics?',
      message: 'Enter true or false',
      required: true,
      type: 'boolean'
    },
    apiHost: {
      ask: () => Prompt.history('enable').value === true,
      description: 'Enter API hostname to send mongo stats',
      required: true
    },
    apiPort: {
      ask: () => Prompt.history('enable').value === true,
      default: 443,
      description: 'Enter API port to send mongo stats',
      required: false
    },
    apiTLS: {
      ask: () => Prompt.history('enable').value === true,
      default: true,
      description: 'API TLS enabled?',
      required: false,
      type: 'boolean'
    },
    apiToken: {
      ask: () => Prompt.history('enable').value === true,
      description: 'Enter API admin token',
      required: true
    }
  }
}
