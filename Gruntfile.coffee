module.exports = (grunt) ->
  TEMPLATE_LANG         = grunt.option('lang') or "en"

  WEBAPP_ROOT           = 'www/webapp/static/webapp'
  
  WEBAPP_SPEC_DIR       = "#{WEBAPP_ROOT}/spec/"
  WEBAPP_TMP_DIR        = "#{WEBAPP_ROOT}/tmp/"
  WEBAPP_BUILD_DIR      = "#{WEBAPP_ROOT}/build/"
  WEBAPP_IMG_DIR        = "#{WEBAPP_ROOT}/img/"
  WEBAPP_SASS_DIR       = "#{WEBAPP_ROOT}/sass/"
  WEBAPP_CSS_DIR        = "#{WEBAPP_ROOT}/css/"
  WEBAPP_JS_DIR         = "#{WEBAPP_ROOT}/js/"
  WEBAPP_JS_VENDOR_DIR  = "#{WEBAPP_JS_DIR}/vendor/"
  WEBAPP_JS_EMBER_DIR   = "#{WEBAPP_JS_DIR}/app/"
  WEBAPP_JS_I18N_DIR    = "#{WEBAPP_JS_DIR}/i18n/"

  GLOB_COFFEE_FILES     = "**/*.coffee"
  GLOB_SASS_FILES       = "**/*.sass"
  GLOB_CSS_FILES        = "**/*.css"
  GLOB_JS_FILES         = "**/*.js"

  EMBER_TEMPLATES_LANG_DEST = "www/webapp/static/webapp/build/templates." + TEMPLATE_LANG + ".js"
  EMBER_TEMPLATES_LANG_DICT = {}
  EMBER_TEMPLATES_LANG_DICT[EMBER_TEMPLATES_LANG_DEST] = WEBAPP_ROOT + "/handlebars/" + TEMPLATE_LANG + "/**/*.handlebars"

  EMBER_TEMPLATES_LANG_DEST_MINIFY = "www/webapp/static/webapp/build/templates." + TEMPLATE_LANG + ".min.js"
  EMBER_TEMPLATES_LANG_DICT_MINIFY = {}
  EMBER_TEMPLATES_LANG_DICT_MINIFY[EMBER_TEMPLATES_LANG_DEST_MINIFY] = WEBAPP_BUILD_DIR + "templates." + TEMPLATE_LANG + ".js"

  grunt.initConfig

    #
    # Coffee script compilation
    #
    coffee:
      webapp_js_ember:
        expand: true
        cwd: WEBAPP_JS_DIR
        src: GLOB_COFFEE_FILES
        dest: WEBAPP_TMP_DIR
        ext: '.js'
      webapp_js_spec:
        options:
          bare: true
        files:
          "www/webapp/static/webapp/spec/specs.js": ["#{WEBAPP_ROOT}/spec/*.coffee", "#{WEBAPP_ROOT}/spec/support/**/*.coffee", "#{WEBAPP_ROOT}/spec/unit/**/*.coffee"]

    #
    # Minify js files using UglifyJS
    #
    uglify:
      options:
        report: "min"
        compress: true
        mangle:
          except: ['Vosae', 'Ember', 'Em']
      webapp_js_vendor:
        options:
          compress: false
        files:
          "www/webapp/static/webapp/build/vendor.min.js": [WEBAPP_BUILD_DIR + "vendor.js"]
      webapp_js_ember:
        files:
          "www/webapp/static/webapp/build/webapp.min.js": [WEBAPP_BUILD_DIR + "webapp.js"]
      webapp_js_i18n:
        files:
          "www/webapp/static/webapp/build/locales/locale-<%= grunt.option(\"i18n_lang\") %>.min.js": [WEBAPP_BUILD_DIR + "locales/locale-<%= grunt.option(\"i18n_lang\") %>.js"]
      templates:
        files: EMBER_TEMPLATES_LANG_DICT_MINIFY

    #
    # Minify css files using clean-css
    #
    cssmin:
      options:
        report: "min"
        keepSpecialComments: "0"
      webapp:
        files:
          "www/webapp/static/webapp/build/webapp.min.css": [WEBAPP_BUILD_DIR + "webapp.css"]
    
    #
    # Watch directories for changes
    #
    watch:
      options: 
        nospawn: true
      webapp_js_vendor:
        files: [WEBAPP_JS_VENDOR_DIR + GLOB_JS_FILES]
        tasks: ["concat:webapp_js_vendor"]
      webapp_js_ember:
        files: WEBAPP_JS_EMBER_DIR + GLOB_COFFEE_FILES
      webapp_js:
        files: [WEBAPP_TMP_DIR + GLOB_JS_FILES]
        tasks: ["minispade:webapp_js_ember"]
      webapp_sass:
        files: [WEBAPP_SASS_DIR + GLOB_SASS_FILES]
        tasks: ["compass:webapp", "concat:webapp_css"]
      webapp_css:
        files: [WEBAPP_CSS_DIR + GLOB_CSS_FILES]
        tasks: ["concat:webapp_css"]

    #
    # Concatenate files
    #
    concat:
      webapp_js_vendor:
        options:
          separator: ";"
        src: [
          WEBAPP_JS_VENDOR_DIR + "modernizr.min.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.browser.js",
          WEBAPP_JS_VENDOR_DIR + "jquery-ui.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.cookie.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.autogrow.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.fileDownload.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.iframe-transport.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.fileupload.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.fileupload-process.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.fileupload-validate.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.magicSuggest.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.minicolors.js",
          WEBAPP_JS_VENDOR_DIR + "minispade.js",
          WEBAPP_JS_VENDOR_DIR + "bootstrap.js",
          WEBAPP_JS_VENDOR_DIR + "bootstrap-datepicker.js",
          WEBAPP_JS_VENDOR_DIR + "bootstrap-datepicker.lang-all.js",
          WEBAPP_JS_VENDOR_DIR + "bootstrap-timepicker.js",
          WEBAPP_JS_VENDOR_DIR + "bootstrap-tour.js",
          WEBAPP_JS_VENDOR_DIR + "typeahead.js",
          WEBAPP_JS_VENDOR_DIR + "select2.js",
          WEBAPP_JS_VENDOR_DIR + "sugar.js",
          WEBAPP_JS_VENDOR_DIR + "gmap3.js",
          WEBAPP_JS_VENDOR_DIR + "autocomplete.js",
          WEBAPP_JS_VENDOR_DIR + "autonumeric.js",
          WEBAPP_JS_VENDOR_DIR + "accounting.js",
          WEBAPP_JS_VENDOR_DIR + "moment.js",
          WEBAPP_JS_VENDOR_DIR + "moment.lang-all.js",
          WEBAPP_JS_VENDOR_DIR + "twix.js",
          WEBAPP_JS_VENDOR_DIR + "twix.lang-all.js",
          WEBAPP_JS_VENDOR_DIR + "color.js",
          WEBAPP_JS_VENDOR_DIR + "autosize.js",
          WEBAPP_JS_VENDOR_DIR + "fullcalendar.js",
          WEBAPP_JS_VENDOR_DIR + "handlebars.js",
          WEBAPP_JS_VENDOR_DIR + "ember.js",
          WEBAPP_JS_VENDOR_DIR + "ember-data.js"
        ]
        dest: WEBAPP_BUILD_DIR + "vendor.js"
      webapp_js_vendor_prod:
        options:
          separator: ";"
        src: [
          WEBAPP_JS_VENDOR_DIR + "modernizr.min.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.min.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.browser.js",
          WEBAPP_JS_VENDOR_DIR + "jquery-ui.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.cookie.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.autogrow.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.fileDownload.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.iframe-transport.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.fileupload.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.fileupload-process.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.fileupload-validate.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.magicSuggest.js",
          WEBAPP_JS_VENDOR_DIR + "jquery.minicolors.js",
          WEBAPP_JS_VENDOR_DIR + "minispade.js",
          WEBAPP_JS_VENDOR_DIR + "bootstrap.min.js",
          WEBAPP_JS_VENDOR_DIR + "bootstrap-datepicker.js",
          WEBAPP_JS_VENDOR_DIR + "bootstrap-datepicker.lang-all.js",
          WEBAPP_JS_VENDOR_DIR + "bootstrap-timepicker.js",
          WEBAPP_JS_VENDOR_DIR + "bootstrap-tour.js",
          WEBAPP_JS_VENDOR_DIR + "typeahead.js",
          WEBAPP_JS_VENDOR_DIR + "select2.min.js",
          WEBAPP_JS_VENDOR_DIR + "sugar.min.js",
          WEBAPP_JS_VENDOR_DIR + "gmap3.js",
          WEBAPP_JS_VENDOR_DIR + "autocomplete.js",
          WEBAPP_JS_VENDOR_DIR + "autonumeric.js",
          WEBAPP_JS_VENDOR_DIR + "accounting.min.js",
          WEBAPP_JS_VENDOR_DIR + "moment.js",
          WEBAPP_JS_VENDOR_DIR + "moment.lang-all.js",
          WEBAPP_JS_VENDOR_DIR + "twix.min.js",
          WEBAPP_JS_VENDOR_DIR + "twix.lang-all.js",
          WEBAPP_JS_VENDOR_DIR + "color.js",
          WEBAPP_JS_VENDOR_DIR + "autosize.min.js",
          WEBAPP_JS_VENDOR_DIR + "fullcalendar.js",
          WEBAPP_JS_VENDOR_DIR + "handlebars.js",
          WEBAPP_JS_VENDOR_DIR + "ember.min.js",
          WEBAPP_JS_VENDOR_DIR + "ember-data.min.js"
        ]
        dest: WEBAPP_BUILD_DIR + "vendor.js"  
      webapp_js_i18n:
        options:
          separator: ";"
        src: [
          WEBAPP_JS_I18N_DIR + "<%= grunt.option(\"i18n_lang\") %>/djangojs.js",
          WEBAPP_JS_I18N_DIR + "<%= grunt.option(\"i18n_lang\") %>/formats.js"
        ]
        dest: WEBAPP_BUILD_DIR + "locales/locale-<%= grunt.option(\"i18n_lang\") %>.js"
      webapp_css:
        src: [
          WEBAPP_CSS_DIR + "webapp.css"
        ]
        dest: WEBAPP_BUILD_DIR + "webapp.css"

    #
    # Wraps JS files in minispade
    #
    minispade:
      webapp_js_ember:
        options:
          renameRequire: true
          prefixToRemove: WEBAPP_TMP_DIR + "app/"
          removeFileExtension: true
        src: [WEBAPP_TMP_DIR + "app/" + GLOB_JS_FILES]
        dest: WEBAPP_BUILD_DIR + "webapp.js"

    #
    # Compass
    #
    compass:       
      webapp:
        options: 
          basePath: 'www/webapp/'
          config: 'www/webapp/config.rb'
          trace: true

    #
    # Ember templates
    #
    emberTemplates:
      compile:
        options:
          handlebarsPath: WEBAPP_JS_VENDOR_DIR + "handlebars.js"
          templateName: (sourceFile) ->
            to_replace = RegExp("#{WEBAPP_ROOT}/handlebars/#{TEMPLATE_LANG}/")
            sourceFile.replace(to_replace, '')
        files: EMBER_TEMPLATES_LANG_DICT

    #
    # Cleaning
    #
    clean:
      release: [
        WEBAPP_JS_DIR
        WEBAPP_SPEC_DIR
        WEBAPP_TMP_DIR
        WEBAPP_JS_VENDOR_DIR
        WEBAPP_JS_EMBER_DIR
        WEBAPP_SASS_DIR
        WEBAPP_CSS_DIR
      ]

    # 
    # Images minification
    # 
    imagemin:
      dynamic:
        files: [
          expand: true
          cwd: WEBAPP_IMG_DIR
          src: ['**/*.{png,jpg,gif}']
          dest: WEBAPP_IMG_DIR
        ]

  #
  # Events
  #
  grunt.event.on "watch", (action, filepath) ->
    exp  = filepath.split('.')
    base = exp[0]
    ext  = exp[exp.length - 1]

    if ext is "coffee" and base.indexOf(WEBAPP_JS_DIR) != -1
      file = filepath.replace WEBAPP_JS_DIR, ''
      dest = WEBAPP_TMP_DIR
      cwd  = WEBAPP_JS_DIR

      if cwd and dest and file
        grunt.config.set 'coffee',
          changed:
            expand: true
            cwd: cwd
            src: [file]
            dest: dest
            ext: '.js'

        grunt.task.run [
          'coffee:changed'
          'minispade:webapp_js_ember'
        ]

  #
  # Load tasks
  #
  grunt.loadNpmTasks 'grunt-minispade'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-ember-templates'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'

  #
  # Register tasks
  # 
  grunt.registerTask 'default', ['build-dev', 'watch']
  grunt.registerTask 'images', ['imagemin']
  grunt.registerTask 'spec', ['coffee:webapp_js_spec']
  grunt.registerTask 'handlebars', ['emberTemplates', 'uglify:templates']

  grunt.registerTask 'process_i18n_lang', (lang, prod) ->
    grunt.option("i18n_lang", lang)
    tasklist = ['concat:webapp_js_i18n']
    console.log prod
    if prod is 'true'
      tasklist.push 'uglify:webapp_js_i18n'
    grunt.task.run tasklist

  grunt.registerTask 'i18n', (prod) ->
    tasklist = []
    for lang in grunt.file.expand {cwd:WEBAPP_JS_I18N_DIR}, '*'
      tasklist.push('process_i18n_lang:' + lang + ':' + prod)
    grunt.task.run tasklist

  grunt.registerTask 'build-dev', 'Development build', ->
    grunt.config.set 'minispade.options.stringModule', true
    grunt.task.run [
      # Webapp
      'compass:webapp'
      'concat:webapp_css'
      'concat:webapp_js_vendor'
      'coffee:webapp_js_ember'
      'minispade:webapp_js_ember'
      
      # i18n
      'i18n:false'
    ]

  grunt.registerTask 'build-prod', 'Production build', -> 
    grunt.config.set 'minispade.options.stringModule', false
    grunt.config.set 'compass.webapp.options.force', true
    grunt.task.run [
      # Webapp
      'compass:webapp'
      'concat:webapp_css'
      'cssmin:webapp'
      'concat:webapp_js_vendor_prod'
      'uglify:webapp_js_vendor'
      'coffee:webapp_js_ember'
      'minispade:webapp_js_ember'
      'uglify:webapp_js_ember'

      # i18n
      'i18n:true'

      # Cleaning
      'clean:release'
    ]