gulp      =   require 'gulp'
watch     =   require 'gulp-watch'
sequence  =   require 'gulp-run-sequence'
inject    =   require 'gulp-inject'
_         =   require 'lodash'
args      =   require('yargs')
                .alias('coffee', 'coffee-script')
                .alias('styl', 'stylus')
                .boolean(['coffee', 'stylus', 'less', 'sass'])
                .default('port', 8001)
                .argv
spawn     =   require('child_process').spawn
exec      =   require('child_process').exec
fs        =   require 'fs'
path      =   require 'path'
coffee    =   require 'gulp-coffee'
less      =   require 'gulp-less'
sass      =   require 'gulp-sass'
stylus    =   require 'gulp-stylus'
clean     =   require 'gulp-clean'
concat    =   require 'gulp-concat'
ngFileSort =  require 'gulp-angular-filesort'
livereload = require 'gulp-livereload'
nib       =   require 'nib'
del       =   require 'del'
mainBowerFiles  =   require 'main-bower-files'
port      =   null
tasks     =   null

srcBase     =   "demos/src/"
srcBaseJS   =   "#{srcBase}js/**/"
srcBaseCSS  =   "#{srcBase}css/**/"

destBase    =   "demos/dest/"
destBaseJS  =   "#{destBase}js/**/"
destBaseCSS =   "#{destBase}css/**/"

vendorsPathJS  =  "#{destBase}/vendors/js/"
vendorsPathCSS =  "#{destBase}/vendors/styles/"

paths       =
  src :
    js     : "#{srcBaseJS}*.js"
    coffee : "#{srcBaseJS}*.coffee"
    css    : "#{srcBaseCSS}*.css"
    stylus : "#{srcBaseCSS}*.styl"
    less   : "#{srcBaseCSS}*.less"
    sass   : "#{srcBaseCSS}*.scss"
  dest :
    js : "#{destBaseJS}*.js"
    css: "#{destBaseCSS}*.css"
  vendors :
    js  : "#{vendorsPathJS}/**/*.js"
    css : "#{vendorsPathCSS}/**/*.css"


availTasks    = ['coffee', 'stylus', 'less', 'sass', 'js', 'css']
defaultTasks  = ['demon', 'js', 'css', 'watch']
injectTarget  = 'index.html'

getTasks = (args)->
  _tasks = []
  _.forOwn args, (value, key)->
    if value is true
      task = _.findWhere(availTasks, key)
      if task
        _tasks.push task

  _.uniq _tasks

getIncludes = ->
  fs.readFileSync('includes.json', {
    encoding : 'utf8'
  })

getPath = (path)->
  _path = path.split('/')
  _path.splice(1,1)

  return _path.join('/')

gulp.task 'cleanCSS', ->
  gulp.src paths.dest.css, {read: false}
    .pipe(clean())

gulp.task 'cleanJS', ->
  gulp.src paths.dest.js, {read: false}
    .pipe(clean())

gulp.task 'js', ->
  gulp.src paths.src.js
    .pipe gulp.dest("#{destBase}js/")
    .pipe livereload()

gulp.task 'cleanVendor:js', ->
  gulp.src paths.vendors.js, {read: false}
    .pipe(clean())

gulp.task 'cleanVendor:css', ->
  gulp.src paths.vendors.css, {read: false}
    .pipe(clean())

gulp.task 'coffee', ->
  gulp.src paths.src.coffee
    .pipe(coffee({bare:true}))
    .pipe(gulp.dest("#{destBase}js/"))
    .pipe livereload()

gulp.task 'css', ->
  gulp.src paths.src.css
    .pipe gulp.dest("#{destBase}css/")
    .pipe livereload()

gulp.task 'stylus', ->
  gulp.src paths.src.stylus
    .pipe(stylus({use: nib()}))
    .pipe(gulp.dest("#{destBase}css/"))
    .pipe livereload()

gulp.task 'less', ->
  gulp.src paths.src.less
    .pipe(less({
      paths : [path.join __dirname, 'src/css/']
    }))
    .pipe(gulp.dest("#{destBase}css/"))
    .pipe livereload()

gulp.task 'sass', ->
  gulp.src paths.src.sass
    .pipe(sass())
    .pipe(gulp.dest("#{destBase}css/"))
    .pipe livereload()

gulp.task 'inject:author', ->
  _target  = gulp.src injectTarget
  _sources = gulp.src(["#{paths.dest.js}", "#{paths.dest.css}"], {read: false})

  _target
    .pipe inject(_sources)
    .pipe gulp.dest "./"

gulp.task 'inject:vendor', ->
  _target   = gulp.src injectTarget
  _includesJS = JSON.parse(getIncludes()).deps.js
  _includesCSS = JSON.parse(getIncludes()).deps.css

  gulp.src(_includesJS)
    .pipe(concat('vendors.js'))
    .pipe(gulp.dest(vendorsPathJS))

  gulp.src(_includesCSS)
    .pipe(concat('vendors.css'))
    .pipe(gulp.dest(vendorsPathCSS))

  _sources = gulp.src(["#{paths.vendors.js}", "#{paths.vendors.css}"], {read: false})

  _target
    .pipe inject(_sources,{
      name : 'vendor'
    })
    .pipe gulp.dest './'

gulp.task 'inject', ->
  sequence 'inject:vendor', 'inject:author'

gulp.task 'demon', ->
  port    = port || args.port
  python  = spawn 'python', ["-m", "SimpleHTTPServer", "#{port}"], { stdio : 'inherit', stderr: 'inherit'}

gulp.task 'watch', ->
  livereload.listen()
  gulp.watch paths.src.js, ['js']
  gulp.watch paths.src.coffee, ['coffee']
  gulp.watch paths.src.css, ['css']
  gulp.watch paths.src.less, ['less']
  gulp.watch paths.src.stylus, ['stylus']
  gulp.watch paths.src.sass, ['sass']

  gulp.watch "#{destBase}**/*.*", ['inject']


gulp.task 'default', ->
  port  = args.port
  sequence 'coffee', 'stylus', 'js', 'css', 'cleanVendor:js', 'cleanVendor:css', 'inject', 'watch'