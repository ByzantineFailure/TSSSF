TSSSF
=====

Angular/Rails implementation of an MLP card game.


Dev Environment Notes
=====
We will be using Ruby 2.1.2 with Rails 4.  I HIGHLY recommend developing on linux.  I am fairly certain that our websocket library (websocket-rails) does not run without the hiredis gem installed.  While we will not be leveraging the functionality in websocket-rails that requires hiredis, we do plan on using redis for a significant portion of our functionality.


I also sincerely recommend installing Ruby through RVM:

Installing RVM (Linux): http://rvm.io/rvm/install

Installing RVM (Windows -> cygwin, discouraged):   http://blog.developwithpassion.com/2012/03/30/installing-rvm-with-cygwin-on-windows/

Installing RVM (Mac OSX): https://jewelrybox.unfiniti.com/

Installing and running rails: http://railsapps.github.io/installing-rails.html
