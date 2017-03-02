const { exec } = require('child_process')
const Path = require('path')

const { apply, series } = require('async')
const Mkdirp = require('mkdirp')
const Logger = require('@xervo/logger')('setup')

const CONF_DIR = Path.resolve('/opt/conf')
const KEYFILE_PERMS = 400
const MONGOD_UID = 0999

const createInstallDirectory = (install, done) => {
  Logger.debug('createInstallDirectory', install)

  const path = Path.resolve(CONF_DIR, install)
  Mkdirp(path, done)
}

const createKeyfile = (install, done) => {
  Logger.debug('createKeyfile', install)

  const path = Path.resolve(CONF_DIR, install, 'keyfile')
  const command = `openssl rand -base64 756 > ${path}`

  exec(command, done)
}

const setKeyfilePerms = (install, done) => {
  Logger.debug('setKeyfilePerms', install)

  const path = Path.resolve(CONF_DIR, install, 'keyfile')
  const command = [
    `chmod ${KEYFILE_PERMS} ${path}`,
    `chown ${MONGOD_UID} ${path}`
  ].join(' &&')

  exec(command, done)
}

exports.init = (install, done) => {
  Logger.debug('init', { install })

  series({
    createInstallDirectory: apply(createInstallDirectory, install),
    createKeyfile: apply(createKeyfile, install),
    setKeyfilePerms: apply(setKeyfilePerms, install)
  }, done)
}
