TSSSF
=====

Angular/Rails implementation of an MLP card game.

Project Structure Notes
=====
Angular components are held in app/assets/javascripts/angular/

Angular templates are held in public/templates/

Folders underneath app/assets/javascripts/angular/ need to be added individually to application.js as //= require_tree entries as requiring ./services before ./controllers is fairly important.


Dev Environment Notes
=====
We will be using Ruby 2.1.2 with Rails 4.  I HIGHLY recommend developing on linux.  I am fairly certain that our websocket library (websocket-rails) does not run without the hiredis gem installed.  While we will not be leveraging the functionality in websocket-rails that requires hiredis, we do plan on using redis for a significant portion of our functionality.


I also sincerely recommend installing Ruby through RVM:

Installing RVM (Linux): http://rvm.io/rvm/install

Installing RVM (Windows -> cygwin, discouraged):   http://blog.developwithpassion.com/2012/03/30/installing-rvm-with-cygwin-on-windows/

Installing RVM (Mac OSX): https://jewelrybox.unfiniti.com/

Installing and running rails: http://railsapps.github.io/installing-rails.html


For my own reference and those who may want it: https://www.honeybadger.io/blog/2013/12/11/beginners-guide-to-angular-js-rails
