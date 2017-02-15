const Exec = require('child_process')
const Logger = require('@xervo/logger')('docker')

const PROJECT_NAME = 'mongo-rs'
const COMMAND_OPTS = { stdio: 'inherit' }

const getDockerComposeArgs = (command, template) => {
  const args = [
    '--file', template,
    '--project-name', PROJECT_NAME
  ]

  if (command === 'up') args.push('up', '-d', '--no-build')
  else args.push(command)

  return args
}

const getRunCommandArgs = (container, command) => [
  'exec',
  '--interactive',
  '--tty',
  container,
  command
]

exports.compose = (action, template, done) => {
  Logger.debug('compose', { action, template })

  const args = getDockerComposeArgs(action, template)
  const command = Exec.spawn('docker-compose', args, COMMAND_OPTS)

  command.on('error', done)
  command.on('close', (code) => {
    if (code !== 0) return done(new Error(`docker-compose ${action} failed`))
    done()
  })
}

exports.runCommand = (container, cmd, done) => {
  Logger.debug('runCommand', { container, cmd })

  const args = getRunCommandArgs(container, cmd)
  const command = Exec.spawn('docker', args)

  command.on('error', done)
  command.on('close', (code) => {
    if (code !== 0) return done(new Error('docker exec command failed'))
    done()
  })
}

exports.replicaSetInit = (options, done) => {
  const command = 'mongo "rs.initiate()"'
  exports.runCommand('mongo', command, done)
}

exports.addSecondary = (ip, { mongo }, done) => {
  const secondary = {
    host: `${ip}:27017`,
    priority: 2,
    _id: 1
  }

  const commands = [
    'mongo',
    'use admin',
    `db.auth(${mongo.username}, ${mongo.password})`,
    `rs.add(${secondary})`
  ]

  exports.runCommand('mongo', commands, done)
}

exports.addArbiter = (ip, { mongo }, done) => {
  const commands = [
    'mongo',
    'use admin',
    `db.auth(${mongo.username}, ${mongo.password})`,
    `rs.addArb(${ip}:27017)`
  ]

  exports.runCommand('mongo', commands, done)
}
