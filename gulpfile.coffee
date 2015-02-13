gulp = require 'gulp'
browserify = require 'gulp-browserify'
coffeelint = require 'gulp-coffeelint'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'

gulp.task 'browserify', ['coffeelint'], ->
  gulp.src './src/**/*.coffee', read: off
  .pipe browserify
    transform: ['coffeeify']
    extensions: ['.coffee']
  .pipe rename 'all.js'
  .pipe uglify()
  .pipe gulp.dest './dist'

gulp.task 'coffeelint', ->
  gulp.src [
    './gulpfile.coffee'
    './src/**/*.coffee'
  ]
  .pipe coffeelint()
  .pipe coffeelint.reporter()

gulp.task 'watch', ->
  gulp.watch './src/**/*.coffee', ['browserify']

gulp.task 'default', ['coffeelint', 'browserify', 'watch']