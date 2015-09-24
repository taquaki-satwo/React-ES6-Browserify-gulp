#
# gulpfile.coffee
#

sources =
  jade   : './src/jade/**/*.jade'
  js     : ['./src/js/**/*.js', './src/js/**/*.jsx']
  scss   : './src/scss/**/*.scss'


autoprefixer   = require 'gulp-autoprefixer'
browserify = require 'browserify'
debowerify = require 'debowerify'
concat     = require 'gulp-concat'
gulp       = require 'gulp'
jade       = require 'gulp-jade'
scss       = require 'gulp-sass'
source     = require 'vinyl-source-stream'
webserver  = require 'gulp-webserver'


#
# task
#

# default
gulp.task 'default', ['build']
gulp.task 'build', [
  'build:css',
  'build:jade',
  'build:js',
  'build:watch'
  'build:webserver'
]


# watch
gulp.task 'build:watch', ->
  gulp.watch sources.jade, ['build:jade']
  gulp.watch sources.js,   ['build:js']
  gulp.watch sources.scss, ['build:css']


# html
gulp.task 'build:jade', ->
  gulp.src sources.jade
      .pipe jade { pretty: true }
      .pipe gulp.dest './dist/'


# css
gulp.task 'build:css', ->
  gulp.src sources.scss
      .pipe scss()
      .pipe autoprefixer()
      .pipe concat 'style.css'
      .pipe gulp.dest './dist/css/'


# js
gulp.task 'build:js', ->
  browserify
    entries: ['./src/js/main.jsx', './src/js/main.js']
    transform: ['babelify', 'debowerify']
  .bundle()
  .pipe source 'bundle.js'
  .pipe gulp.dest "./dist/js/"


# web server
gulp.task 'build:webserver', ->
  gulp.src './dist/'
      .pipe webserver { host: '127.0.0.1', livereload: true }
