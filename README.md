# Hollywood

Used to build the Drupal 7 source code for my website, www.aaronschachter.com.

Docs: https://github.com/aaronschachter/hollywood/wiki

Contents:

* **bin**: Scripts for local development and pushing releases to the [distribution repo](https://github.com/aaronschachter/hollywood-dist)
* **config**: (dir) Contains settings for local development.
* **lib**: (dir) Custom Drupal 7 code (currently, the only custom code is the site theme)
* **hollywood.make**: Make file for building the site via `drush make`

### Credits
This architecture and the `bin/bldr.sh` script is borrowed quite liberally from the [DoSomething.org source code](https://github.com/dosomething/dosomething), which also builds via `drush make` and uses bash scripting to simplify development.

The theme is built upon [Twitter Bootstrap](http://getbootstrap.com/) and the [Start Bootstrap "Simple Sidebar" template](http://startbootstrap.com/template-overviews/simple-sidebar/).
