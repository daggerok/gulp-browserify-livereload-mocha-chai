mocha       =
  src     : 'src/**/*.*'
  sources : 'sources.js'
  test    : 'test/**/*.*'
  tests   : 'tests.js'
  mocha   : 'mocha/'
  any     : 'mocha/**/*.*'
  dist    : 'dist/'
gulp        = require 'gulp'
browserify  = require 'gulp-browserify'
concat      = require 'gulp-concat'
livereload  = require 'gulp-livereload'
open        = require 'gulp-open'

gulp.task 'sources', ->
  gulp.src(mocha.src)
    .pipe browserify
      debug: true
      insertGlobals: true
    .pipe(concat(mocha.sources))
    .pipe(gulp.dest mocha.mocha)

gulp.task 'tests', ['sources'], -> 
  gulp.src(mocha.test)
    .pipe browserify
      debug: true
      insertGlobals: true
    .pipe(concat(mocha.tests))
    .pipe(gulp.dest mocha.mocha)

gulp.task 'deploy', ['sources', 'tests'], -> 
  gulp.src([
      'node_modules/chai/chai.js'
      mocha.any
    ])
    .pipe(gulp.dest mocha.dist)
    .pipe(livereload())

gulp.task 'default', ['sources', 'tests', 'deploy']

gulp.task 'tdd', ['default'], ->
  livereload.listen basePath: mocha.dist
  
  gulp.watch [mocha.src], ['sources']
  gulp.watch [mocha.test], ['tests']
  gulp.watch [mocha.any], ['deploy']

  gulp.src(mocha.dist).pipe(open uri: 'http://localhost:3000')
