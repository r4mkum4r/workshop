{exec} = require "child_process"
fs = require 'fs'

task 'say:hello', 'Description of task', ->
  console.log 'Hello World!'

option '-e', '--environment [ENVIRONMENT_NAME]', 'set the environment for `task:withDefaults`'
task 'task:withDefaults', 'Description of task', (options) ->
  options.environment or= 'production'

task 'lint',  'Linting JS files', ->
  exec "coffee -o demos/dest/js/ -c demos/src/js/*.coffee", (err, stdout, stderr) ->
    throw err if err
    console.log "jshint demos/dest/js/**.js"

appFiles  = [
  'demos/src/js/main',
  'demos/src/js/controller'
]

task 'build:js', 'Building app.js', ->
  appContents = new Array remaining = appFiles.length
  for file, index in appFiles then do (file, index) ->
    fs.readFile "#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'demos/dest/js/app.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee --compile demos/dest/js/app.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
    