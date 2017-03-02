const { resolve } = require('path')
const { readFileSync, writeFile } = require('fs')

const Handlebars = require('handlebars')
const Logger = require('@xervo/logger')('generateTemplate')
const { series } = require('async')

const CONF_DIR = resolve('/opt/conf')
const ENCODING = { encoding: 'utf8' }
const TEMPLATE_DIR = resolve(__dirname, '..', 'tmpl')

const compileConf = (filename, options) => {
  const path = resolve(TEMPLATE_DIR, filename)
  const source = readFileSync(path, ENCODING)
  const config = Handlebars.compile(source)

  return config(options)
}

const saveConf = (install, filename, conf, done) => {
  Logger.debug('saveConf', filename)

  const path = resolve(CONF_DIR, install, filename)
  writeFile(path, conf, ENCODING, (err) => {
    if (err) return done(err)
    done(null, path)
  })
}

module.exports = (options, done) => {
  series({
    mongo: (next) => {
      const confName = 'mongo.conf'
      const conf = compileConf(confName, options)
      saveConf(options.mongo.install, confName, conf, next)
    },
    user: (next) => {
      const confName = 'initMongoUser.js'
      const conf = compileConf(confName, options)
      saveConf(options.mongo.install, confName, conf, next)
    },
    replicaSet: (next) => {
      const confName = 'initRS.js'
      const conf = compileConf(confName, options)
      saveConf(options.mongo.install, confName, conf, next)
    },
    docker: (next) => {
      const confName = `docker-compose.${options.mongo.type}.yml`
      const conf = compileConf(confName, options)
      saveConf(options.mongo.install, 'docker-compose.yml', conf, next)
    }
  }, done)
}
