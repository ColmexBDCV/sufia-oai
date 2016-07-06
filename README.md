Digital Collections System
==========================

[Fedora/Hydra/Sufia](1) digital object repository.

Prerequisites
-------------

The following dependencies must be installed to develop this application.
  
  * [Ruby](2) 2.3 with [Bundler](3)
  * [Redis](4), a key-value store
  * [ImageMagick](5) with JPEG-2000 support
  * [FITS](6) 0.8.x (0.8.5 is known to be good)
  * [LibreOffice](7)
  * [Ghostscript](8) (may be required if not bundled with LibreOffice)

While not required, OS X users may find the [Homebrew](9) package manager
helpful to manage dependency installation.

Note that this project should run on OS X, Unix, or Unix-like operating systems.
It has not been tested on Microsoft Windows.

### Ruby

First, you'll need a working Ruby installation. You can install this via your
operating system's package manager, but we recommend using a dedicated Ruby
version manager such as [chruby](10), [RVM](11), or rbenv.

We recommend Ruby 2.3.

### Characterization

  1. [Download a copy of FITS](http://projects.iq.harvard.edu/fits/downloads)
     (see above to pick a known working version) and unpack it somewhere on your
     machine.
  2. Mark fits.sh as executable: `chmod a+x fits.sh`
  3. Run `fits.sh -h` from the command line and see a help message to ensure
     FITS is properly installed

### Derivatives

Install LibreOffice. If `which soffice` returns a path, you're done. Otherwise,
add the full path to `soffice` to the `.env` file (see below). On OSX, soffice
is inside LibreOffice.app. Your path may look like
`//LibreOffice.app/Contents/MacOS/`

You may also require [ghostscript](8) if it does not come with your compiled
version LibreOffice. `brew install ghostscript` should resolve the dependency on
a Mac.

Installation
------------

Change to the project directory, be sure the correct version of Ruby is in use,
and install all gem dependencies:

    $ cd sufia7
    $ ruby -v
    $ bundle install

Create the development SQLite database and load the schema:

    $ bundle exec rake db:migrate

Create a `.env` file to hold environment variables for this application. This
file will be loaded each time the server is started. See `.env.example` for
details. Specifically, you should set `FITS_PATH` to the full file system path
to fits.sh (see above) and `LIBREOFFICE_PATH` if needed.

    $ cp .env.example .env

Next, you will need to start Solr and Fedora manually to download and configure
their dependencies. Run each of the commands below, wait for the service to
start, the use `Ctrl-C` to close the program.

    $ solr_wrapper -d solr/config/ --collection_name hydra-development
    $ fcrepo_wrapper -p 8984

Use
---

Start Redis, Solr, and Fedora using a single foreman command:

    $ bundle exec foreman start

Then, in a separate terminal window, start the Rails development server:

    $ bundle exec rails start

You can now navigate to the Sufia 7 application at `http://localhost:3000`. You
can also access Solr at `http://localhost:8983/` and Fedora at
`http://localhost:8984/`.

### Creating initial admin user and role

An administrative user needs to be created to access all the features of Sufia.
First, visit `http://localhost:3000/users/sign_in` and create an account. Next,
open a Rails console to set up admin access:

    $ bundle exec rails c
    > r = Role.create name: "admin"
    > r.users << User.find_by_user_key("your_user_email@example.com")
    > r.save


[1]: https://github.com/projecthydra/sufia
[2]: https://www.ruby-lang.org/en/
[3]: http://bundler.io
[4]: http://redis.io
[5]: http://www.imagemagick.org/script/index.php
[6]: http://projects.iq.harvard.edu/fits/
[7]: https://www.libreoffice.org
[8]: http://www.ghostscript.com/
[9]: http://brew.sh
[10]: https://github.com/postmodern/chruby
[11]: https://rvm.io
