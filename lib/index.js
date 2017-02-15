const Docker = require('./docker')
const GenerateTemplate = require('./generateTemplate')
const Prompt = require('./prompt')
const Setup = require('./setup')

const ACTIONS = ['down', 'restart', 'up']

const handleComposeCommand = (action, composePath, done) => {
  if (!composePath) return done(new Error('composePath required'))
  Docker.compose(action, composePath, done)
}

const createNetwork = (done) => {
  Prompt((err, results) => {
    if (err) return done(err)

    Setup.init(results.mongo.install, (err) => {
      if (err) return done(err)

      GenerateTemplate(results, (err, { docker }) => {
        if (err) return done(err)

        handleComposeCommand('up', docker, done)
      })
    })
  })
}

module.exports = (action, options, done) => {
  if (ACTIONS.indexOf(action) === -1) return done(new Error('Unsupported action'))
  if (action === 'up') return createNetwork(done)

  handleComposeCommand(action, options, done)
}
