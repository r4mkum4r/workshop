module.exports = function(grunt) {

    // Simple Tasks
    grunt.initConfig({

        jshint: {
            scripts: {
                src: ['demos/src/js/**.js']
            },

            tests: {
                src: 'demos/tests/**.js'
            }
        },

        uglify: {
            scripts: {
                expand: true,
                cwd: 'demos/src/js/',
                src: '**.js',
                dest: 'demos/dest/js/',
                ext: '.min.js'
            }
        },

        less: {
            styles: {
                files: {
                    'demos/dest/css/app.css': 'demos/src/css/app.less'
                }
            }
        },

        watch: {
            scripts: {
                files: 'demos/src/js/**.js',
                task: 'jshint:scripts'
            },

            styles: {
                files: 'demos/src/css/**.less',
                task: 'less:styles'
            }
        }

    });

    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.registerTask('default', ['jshint', 'less']);
    grunt.registerTask('build', ['jshint', 'uglify', 'less']);


    // Dynamic Task running
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        copy: {
            dist: {
                src: 'build/<%= pkg.name %>.js',
                dest: 'dist/<%= pkg.name %>-<%= pkg.version %>.js'
            }
        }

    });

    // Tasks with Options
    grunt.config('env', grunt.option('env') || process.env.GRUNT_ENV || 'development');
    grunt.config('compress', grunt.config('env') === 'production');

    grunt.loadNpmTasks('less');
    grunt.config('less', {
        styles: {
            src: 'styles/index.less',
            dest: 'build/styles.css',
            options: {
                compress: grunt.config('compress')
            }
        }
    });

    grunt.loadNpmTasks('uglify');
    grunt.config('uglify', {
        sources: {
            src: 'scripts/index.js',
            dest: 'build/index.min.js'
        }
    });

    var defaultTasks = ['less'];
    if(grunt.config('compress')) defaultTasks.push('uglify');
    grunt.registerTask('default', defaultTasks);


};