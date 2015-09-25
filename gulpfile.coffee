#
# gulpfile.coffee
#

sources =
  bower : './bower.json'
  jade  : './src/jade/**/*.jade'
  scss  : './src/scss/**/*.scss'
  dist  : './dist/'


autoprefixer   = require 'gulp-autoprefixer'
browserify     = require 'browserify'
debowerify     = require 'debowerify'
concat         = require 'gulp-concat'
cssmin         = require 'gulp-cssmin'
filter         = require 'gulp-filter'
gulp           = require 'gulp'
jade           = require 'gulp-jade'
less           = require 'gulp-less'
mainBowerFiles = require 'gulp-main-bower-files'
scss           = require 'gulp-sass'
source         = require 'vinyl-source-stream'
uglify         = require 'gulp-uglify'
webserver      = require 'gulp-webserver'


#
# task
#

# default
gulp.task 'default', ['build']
gulp.task 'build', [
  'build:watch',
  'build:lib',
  'build:css',
  'build:jade',
  'build:js',
  'build:webserver'
]


# watch
gulp.task 'build:watch', ->
  gulp.watch sources.bower, ['build:lib']
  gulp.watch sources.jade,  ['build:jade']
  gulp.watch sources.js,    ['build:js']
  gulp.watch sources.scss,  ['build:css']


# bower
gulp.task 'build:lib', ->
  jsFilter   = filter '**/*.js'
  cssFilter  = filter '**/*.css', {restore: true}
  lessFilter = filter '**/*.less'

  gulp.src sources.bower
      .pipe mainBowerFiles()
      .pipe jsFilter
      .pipe concat 'lib.js'
      .pipe uglify { preserveComments: 'some' }
      .pipe gulp.dest sources.dist + 'lib/'

  gulp.src sources.bower
      .pipe mainBowerFiles()
      .pipe cssFilter
      .pipe gulp.dest './src/lib/'
      .pipe cssFilter.restore
      .pipe lessFilter
      .pipe less()
      .pipe gulp.dest './src/lib/'

  gulp.src './src/lib/**/*.css'
      .pipe concat 'lib.css'
      .pipe cssmin()
      .pipe gulp.dest sources.dist + 'lib/'


# html
gulp.task 'build:jade', ->
  gulp.src sources.jade
      .pipe jade { pretty: true }
      .pipe gulp.dest sources.dist


# css
gulp.task 'build:css', ->
  gulp.src sources.scss
      .pipe scss()
      .pipe autoprefixer()
      .pipe concat 'style.css'
      .pipe cssmin()
      .pipe gulp.dest sources.dist + 'css/'


# js
gulp.task 'build:js', ->
  browserify
    entries: ['./src/js/main.jsx', './src/js/main.js']
    transform: ['babelify', 'debowerify']
  .bundle()
  .pipe source 'bundle.js'
  .pipe gulp.dest sources.dist + 'js/'


# web server
gulp.task 'build:webserver', ->
  gulp.src sources.dist
      .pipe webserver { host: '127.0.0.1', livereload: true }
