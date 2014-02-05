# Vosae web client

> This is the [Vosae](https://www.vosae.com/) webapp.  
> It requires the Vosae app backend, available on Github repo [naeka/vosae-app](https://github.com/Naeka/vosae-app/).

---

| Branch | Travis-CI build status |
| :--- | --- |
| master (ready for production) | [![Build Status](https://travis-ci.org/Naeka/vosae-web.png?branch=master)](https://travis-ci.org/Naeka/vosae-web) |
| develop | [![Build Status](https://travis-ci.org/Naeka/vosae-web.png?branch=develop)](https://travis-ci.org/Naeka/vosae-web) |

---

The Vosae Web client is powered by the amazing javascript framework **Ember.js** and its data persistence library **Ember-data**.


You need Python 2.7. It should be on your system if you have a modern operating system.


## Install the application

#### First, clone the repository:

```bash
$ git clone git@github.com:Naeka/vosae-web.git
$ cd vosae-web/
```

#### Build the virtualenv

*Using [virtualenvwrapper](http://virtualenvwrapper.readthedocs.org/) - recommanded:*

```bash
$ mkvirtualenv vosae-web
```

*Or simply with the [virtualenv tool](http://www.virtualenv.org/):*

```bash
$ virtualenv --python=python2.7 --distribute ./
$ source bin/activate
```

#### Install Python requirements **in the virtualenv**:

```bash
(vosae-web)$ pip install -r requirements.txt
```

    
## Manage static files

The Vosae Web client handles static files with [Grunt](http://gruntjs.com/).


You need both Node.js and Node Package Manager (npm) installed on your system.  
**If Node isn't on your system, [install it now](http://nodejs.org/download/)!**


#### First, install grunt dependencies on your system:

```bash
$ gem install compass
$ gem install sass
$ gem install sass-rails
$ gem install bootstrap-sass --version 3.1.0.1
$ gem install --pre sass-css-importer
```

#### Install Grunt:

```bash
$ npm install -g grunt-cli
```
    
#### Finally, on the root of vosae-web:

```bash
$ npm install
```
    
> If it doesn't work (on MacOS), add `/usr/local/share/npm/bin` to `/etc/paths`
    
    
#### Now you can generate static files
    
Build files for dev and watch directories for changes

```bash
$ grunt
```
    
**Only** build files for development

```bash
$ grunt build-dev
```



## Launch the dev server

#### Settings


Prior to launch the server, an app endpoint (auth, api) settings must be defined.
The `VOSAE_APP_ENDPOINT` environment variable is used for this purpose.

For development, it can be more convenient to set this in a local settings file (not tracked by Git).  
In this case, create a `local.py` file in the `settings` module and fill with:

> Warning: Do not add a trailing shash to the endpoint

```python
# -*- coding:Utf-8 -*-

APP_ENDPOINT = 'http://localhost:8000'
```

The development SQLite database must also be common to both `vosae-app` and `vosae-web`.  
This one is by default located (but not tracked) in the `vosae-app/www` directory.  
By default, `vosae-web` assume that it is at the same level of `vosae-app` on your filesystem and should work out of the box.  
If not, you can set the path to your SQLite file in the `VOSAE_SQLITE_DATABASE` environment variable.


#### Ensure that the virtualenv is activated:

`vosae-web` should be in your command prompt, `$PS1` is updated by virtualenv

*Otherwise, activate it using virtualenvwrapper:*

```bash
$ workon vosae-web
```

*Or classic virtualenv:*

```bash
$ cd vosae-web
$ source bin/activate
```

Run the dev server:

```bash
(vosae-web)$ cd vosae-web/www/    
(vosae-web)$ ./manage.py runserver 8001  # Web is run on port 8001 for development
```


##### You can now open [http://localhost:8001](http://localhost:8001)


#### Notes about translation files
Internationalization is handled by django and gettext for both internationalized strings in templates (`django` domain) or javascripts (`djangojs` domain).  
For the javascript part, the `makemessages` management command only parses `.js` files so that it is necessary to compile `.coffee` files first with grunt (either `grunt` or `grunt build-dev` if watching is not necessary).

Because of performance issues, the `javascript_catalog` view is not used, in profit of the `django-statici18n` app.  
Thus, language files can be bundled with static files. Unfortunaletly, these generated static files are conflictual and should be ignored by makemessages.  
This is achieved with this command from the `webapp` app:
```bash
(vosae-web)$ python ../manage.py makemessages -a -d djangojs -i "*djangojs.js" -i "*locale-*.js"
```



## Feature branches naming 

Feature branches are branches used when developing a specific feature. It is used thanks to [gitflow](https://github.com/nvie/gitflow).

To install gitflow, follow [gitflow instructions](https://github.com/nvie/gitflow#installing-git-flow).


## Code conventions 

#### Django

*   **Use of SPACES for indentation** - 4-spaces equivalency
*   Class definitions and top methods separated by **2** blank lines, methods inside a class separated by **1** blank line
*   No maximum line length but try to be clear and align on multiple lines
*   Avoid parentheses use when possible for conditional and loop statements


#### Templates

*   **Use of SPACES for indentation** - 2-spaces equivalency


#### CoffeeScript

*   **Use of SPACES for indentation** - 2-spaces equivalency
*   Use simple quotes for strings, array keys, ...
*   No spaces before parentheses and brackets, carrier return for statements
*   No maximum line length but try to be clear and align on multiple lines
*   Functions must be camelCased
