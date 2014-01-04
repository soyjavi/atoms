module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    meta:
      build   : 'build',
      bower   : 'bower',
      version : '',
      banner  : '/* <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("yyyy/m/d") %>\n' +
              '   <%= pkg.homepage %>\n' +
              '   Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>' +
              ' - Licensed <%= _.pluck(pkg.license, "type").join(", ") %> */\n'

    source:
      # CoffeeScript
      core: [
        'components/quojs/source/quo.coffee'
        'components/quojs/source/quo.ajax.coffee'
        'components/quojs/source/quo.css.coffee'
        'components/quojs/source/quo.element.coffee'
        'components/quojs/source/quo.environment.coffee'
        'components/quojs/source/quo.events.coffee'
        'components/quojs/source/quo.gestures.coffee'
        'components/quojs/source/quo.output.coffee'
        'components/quojs/source/quo.query.coffee'
        'source/*.coffee'
        'source/core/*.coffee'
        'source/class/*.coffee']
      app: [
        'extensions/app/source/*.coffee'
        'extensions/app/source/*/*.coffee']
      example: [
        'extensions/app/demo/source/*/*.coffee'
        'extensions/app/demo/source/*.coffee']
      spec  : [
        'spec/*.coffee'],
      # Stylesheets
      stylus:
        app: [
          'extensions/app/style/reset.styl'
          'extensions/app/style/atom.*.styl'
          'extensions/app/style/molecule.*.styl'
          'extensions/app/style/organism.*.styl'
          'extensions/app/style/template.*.styl'
          'extensions/app/style/app.styl']
        theme: [
          'extensions/app/style/theme/reset.styl'
          'extensions/app/style/theme/atom.*.styl'
          'extensions/app/style/theme/molecule.*.styl'
          'extensions/app/style/theme/organism.*.styl'
          'extensions/app/style/theme/template.*.styl'
          'extensions/app/style/theme/app.styl']
        icons: [
          'extensions/icons/*.styl']


    concat:
      core    : files: '<%=meta.build%>/<%=pkg.name%>.debug.coffee'   : '<%= source.core %>'
      app     : files: '<%=meta.build%>/<%=pkg.name%>.app.coffee'     : '<%= source.app %>'
      example : files: '<%=meta.build%>/<%=pkg.name%>.example.coffee' : '<%= source.example %>'


    coffee:
      core    : files: '<%=meta.build%>/<%=pkg.name%>.debug.js'       : '<%=meta.build%>/<%=pkg.name%>.debug.coffee'
      spec    : files: '<%=meta.build%>/<%=pkg.name%>.spec.js'        : '<%= source.spec %>'
      app     : files: '<%=meta.build%>/<%=pkg.name%>.app.js'         : '<%=meta.build%>/<%=pkg.name%>.app.coffee'
      example : files: '<%=meta.build%>/<%=pkg.name%>.example.js'     : '<%=meta.build%>/<%=pkg.name%>.example.coffee'


    uglify:
      options:  banner: "<%= meta.banner %>", report: "gzip"
      core:
        options: mangle: true
        files: '<%=meta.bower%>/<%=pkg.name%>.js'     : '<%=meta.build%>/<%=pkg.name%>.debug.js'
      app:
        options: mangle: false
        files: '<%=meta.bower%>/<%=pkg.name%>.app.js' : '<%=meta.build%>/<%=pkg.name%>.app.js'


    jasmine:
      pivotal:
        src: [
          '<%=meta.build%>/<%=pkg.name%>.debug.js']
        options:
          vendor: 'spec/components/jquery/jquery.min.js'
          specs: '<%=meta.build%>/<%=pkg.name%>.spec.js',


    stylus:
      app:
        options: compress: true, import: [ '__init']
        files: '<%=meta.bower%>/<%=pkg.name%>.app.css': '<%=source.stylus.app%>'
      theme:
        options: compress: false, import: [ '__init']
        files: '<%=meta.bower%>/<%=pkg.name%>.app.theme.css': '<%=source.stylus.theme%>'
      icons:
        options: compress: false
        files: '<%=meta.bower%>/<%=pkg.name%>.icons.css': '<%=source.stylus.icons%>'


    notify:
      core:
        options: title: 'CoffeeScript', message: 'Core builded.'
      app:
        options: title: 'CoffeeScript', message: 'App builded.'


    watch:
      core:
        files: ['<%= source.core %>']
        tasks: ['concat:core', 'coffee:core', 'uglify:core', 'jasmine', 'notify:core']
      spec:
        files: ['<%= source.spec %>']
        tasks: ['coffee:spec', 'jasmine']
      app:
        files: ['<%= source.app %>']
        tasks: ['concat:app', 'coffee:app', 'uglify:app', 'notify:app']
      example:
        files: ['<%= source.example %>']
        tasks: ['concat:example', 'coffee:example']
      stylus_app:
        files: ['<%= source.stylus.app %>']
        tasks: ['stylus:app']
      stylus_theme:
        files: ['<%= source.stylus.theme %>']
        tasks: ['stylus:theme']
      stylus_icons:
        files: ['<%= source.stylus.icons %>']
        tasks: ['stylus:icons']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['concat', 'coffee', 'uglify', 'stylus', 'jasmine']
