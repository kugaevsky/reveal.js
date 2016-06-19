module.exports = (shipit) ->
  require('shipit-deploy') shipit
  ShipitUtils = require 'shipit-utils'

  shipit.initConfig
      default:
        workspace: '/tmp/slides.kugaevsky.ru'
        deployTo: '/var/www/slides.kugaevsky.ru'
        repositoryUrl: 'git@github.com:kugaevsky/slides.kugaevsky.ru.git'
        dirToCopy: 'public'
        branch: 'master'
        keepReleases: 5
      production:
        servers: 'nick@kugaevsky.ru'
        nginx:
          server: 'slides.kugaevsky.ru'
          port: 80


  deployFlow = [
    'deploy:init'
    'deploy:fetch'
    'deploy:link:node_modules'
    'deploy:install:bower'
    'deploy:compile'
    'deploy:update'
    'deploy:publish'
  ]


  ShipitUtils.registerTask shipit, 'deploy', deployFlow


  shipit.blTask 'deploy:link:node_modules', ->
    shipit.local("cd #{shipit.config.workspace} && ln -nsf #{__dirname}/node_modules")


  shipit.blTask 'deploy:install:bower', ->
    shipit.local("cd #{shipit.config.workspace} && bower install")


  # Compilation and build tasks
  shipit.blTask 'deploy:compile', ->
    shipit.local("cd #{shipit.config.workspace} && gulp compile")

