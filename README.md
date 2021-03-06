TSSSF
=====

Angular/Rails implementation of an MLP card game.

Developed in Ruby 2.1.2

#Project Structure Notes

Angular components are held in app/assets/javascripts/angular/

Angular templates are held in public/templates/

Folders underneath app/assets/javascripts/angular/ need to be added individually to application.js as //= require_tree entries as requiring ./services before ./controllers is fairly important.

#Dev Environment Setup

##Install RVM

#####Installing RVM on Linux: 
  http://rvm.io/rvm/install
  
  If RVM complains about apt-get, run this
  
    sudo apt-get install build-essential openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libc6-dev libncurses5-dev automake libtool bison subversion
  
  then
  
    \curl -sSL https://get.rvm.io | bash -s --autolibs=read-fail

#####Installing RVM on Windows via cygwin (Windows does not support dev environment)

http://blog.developwithpassion.com/2012/03/30/installing-rvm-with-cygwin-on-windows/

#####Installing RVM on Mac OSX (untested)

https://jewelrybox.unfiniti.com/

## Install Ruby and Rails

    rvm install 2.1.2
    rvm use 2.1.2
    gem install rails

#####Further documentation and gudes on installing rails
Installing and running rails: http://railsapps.github.io/installing-rails.html

## Install gems

In the base directory of the project

    bundle install
  
## Run

In the base directory of the project

    rails server

#Additional Reference

For my own reference and those who may want it: https://www.honeybadger.io/blog/2013/12/11/beginners-guide-to-angular-js-rails
