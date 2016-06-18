# Requirements

# Utils
gulp      = require 'gulp'
gutil     = require 'gulp-util'
rename    = require 'gulp-rename'
sh        = require 'shelljs'
fs        = require 'fs'
path      = require 'path'
plumber   = require 'gulp-plumber'
server    = require 'gulp-server-livereload'
through   = require 'through2'

# Sass
sass      = require 'gulp-sass'
minifyCss = require 'gulp-clean-css'
prefix    = require 'gulp-autoprefixer'

# Pug
pug = require 'gulp-pug'

# Images
imagemin = require 'gulp-imagemin'
pngquant = require 'imagemin-pngquant'

# Paths to source
paths =
  pug: ['./src/pug/**/*.pug', '!./src/pug/**/_*.pug']
  images: ['./src/images/**/*']
  output: 'public'


# Gulp compilation and copy tasks
gulp.task 'pug', ->
  gulp.src(paths.pug, { base: './src/pug/' })
    .pipe plumber()
    .pipe pug()
    .pipe gulp.dest("./#{paths.output}/")


gulp.task 'images', (done) ->
  gulp.src paths.images
    .pipe imagemin
      progressive: true
      svgoPlugins: [{removeViewBox: true}]
      use: [pngquant()]
    .pipe gulp.dest("./#{paths.output}/images")


gulp.task 'copy:favicon', (done) ->
  gulp.src './src/images/favicon.ico'
    .pipe gulp.dest("./#{paths.output}")


gulp.task 'bower:install', (done) ->
  gulp.src ''
    .pipe through.obj sh.exec('bower install')


gulp.task 'serve', ['compile', 'watch'], ->
  gulp.src 'public'
    .pipe server
      livereload: true
      open: true


# Gulp watch and default tasks
gulp.task 'copy', ['copy:favicon']
gulp.task 'compile', ['pug', 'images', 'copy']
gulp.task 'default', ['compile', 'watch']


gulp.task 'watch', () ->
  gulp.watch(paths.sass, ['sass'])
  gulp.watch(paths.pug, ['pug'])
  gulp.watch(paths.images, ['images'])


gulp.task 'clean', -> sh.exec("rm -r ./#{paths.output}")
gulp.task 'prepare', -> sh.exec('npm install')
gulp.task 'rebuild', ['clean'], -> sh.exec('npm install')
