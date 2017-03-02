const { auto } = require('async')
const Logger = require('@xervo/logger')('prompt')
const Prompt = require('prompt')

const mongoSchema = require('../schemas/mongo')
const backupSchema = require('../schemas/backup')
const scraperSchema = require('../schemas/scraper')

module.exports = (done) => {
  Logger.debug('prompt')

  const tasks = {
    mongo: (next) => Prompt.get(mongoSchema, next),
    backup: ['mongo', (results, next) => {
      if (['primary', 'arbiter'].indexOf(results.type) !== -1) return next()
      Prompt.get(backupSchema, next)
    }],
    scraper: ['mongo', 'backup', (results, next) => {
      if (['primary', 'arbiter'].indexOf(results.type) !== -1) return next()
      Prompt.get(scraperSchema, next)
    }]
  }

  const handlePromptResponse = (err, result) => {
    if (err) {
      if (err.message === 'canceled') return done(new Error('Prompt canceled'))
      return done(err)
    }

    Logger.debug('prompt success')
    done(null, result)
  }

  Prompt.start()
  auto(tasks, handlePromptResponse)
}
