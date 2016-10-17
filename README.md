Digital Collections System
==========================

[Fedora/Hydra/Sufia][1] digital object repository.

Prerequisites
-------------

The following dependencies must be installed to run this application.

  * [Ruby][2] 2.3.1 with [Bundler][3]
  * [Redis][4], a key-value store
  * [ImageMagick][5] with JPEG-2000 support
  * [FITS][6] 0.8.x (0.8.5 is known to be good)
  * [LibreOffice][7]
  * [Ghostscript][8] (may be required if not bundled with LibreOffice)
  * [Handle.Net Software][9] 8.1.1
  * [PhantomJS][10] >= 1.8.1 (only needed for feature tests)

While not required, macOS users may find the [Homebrew][11] package manager
helpful to manage dependency installation.

Note that this project should run on macOS, Unix, or Unix-like operating systems.
It has not been tested on Microsoft Windows.

### Ruby

First, you'll need a working Ruby installation. You can install this via your
operating system's package manager, but we recommend using a dedicated Ruby
version manager such as [chruby][12], [RVM][13], or rbenv.

We recommend Ruby 2.3.1.

### Characterization

  1. [Download a copy of FITS](http://projects.iq.harvard.edu/fits/downloads)
     (see above to pick a known working version) and unpack it somewhere on your
     machine.
  2. Mark fits.sh as executable: `chmod a+x fits.sh`
  3. Run `fits.sh -h` from the command line and see a help message to ensure
     FITS is properly installed

### Derivatives

Install LibreOffice. If `which soffice` returns a path, you're done. Otherwise,
add the full path to `soffice` to the `.env` file (see below). On macOS, soffice
is inside LibreOffice.app. Your path may look like
`//LibreOffice.app/Contents/MacOS/`

You may also require [ghostscript][8] if it does not come with your compiled
version LibreOffice. `brew install ghostscript` should resolve the dependency on
a Mac.

### Handle System

  1. [Download a copy of the Handle.Net Software](https://www.handle.net/download_hnr.html)
     (see above to pick a known working version) and unpack it somewhere on your
     machine.

### Tests

To run RSpec feature tests, you will need [PhantomJS][10] >= 1.8.1. On macOS,
install via Homebrew:

    $ brew install phantomjs

For other platforms, see the [PhantomJS download page](http://phantomjs.org/download.html)

### Production

When deploying to production, be sure to install Monit on any server used to run
Sidekiq workers. You will need to create a monitored service for Sidekiq (see
`config/monit.example`) and allow the Rails user to execute `monit` via sudo
without a password. For example:

    rails ALL=(ALL) NOPASSWD: /usr/bin/monit
    Defaults:rails !requiretty

Production installations should also set the paths for the minter state file,
derivatives directory, and uploads directory to appropraite locations with
environment variables:

    MINTER_STATEFILE="/path/to/minter-state"
    DERIVATIVES_PATH="/path/to/derivatives"
    UPLOAD_PATH="/path/to/uploads"

These paths should be shared between all production hosts, for example an NFS
share available to a front-end server and back-end Sidekiq host.

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
details.

    $ cp .env.example .env

Specifically, you should set:

  * `FITS_PATH` - the full file system path to fits.sh
  * `LIBREOFFICE_PATH` - the full path to `soffice` (if needed)
  * `HDL_HOME` - path to directory containing the Handle.Net software

Next, you will need to start Solr and Fedora manually to download and configure
their dependencies. Run each of the commands below, wait for the service to
start, the use `Ctrl-C` to close the program.

    $ solr_wrapper -d solr/config/ --collection_name hydra-development
    $ fcrepo_wrapper -p 8984

### Subdirectory installation

If you are planning to run the application in a subdirectory, (i.e. at
`http://example.com/myapp/`) set the `RAILS_RELATIVE_URL_ROOT` environment
variable to the relative path. (ex: `RAILS_RELATIVE_URL_ROOT='/myapp'`)

Use
---

Start Redis, Solr, Fedora, and Sidekiq using a single foreman command:

    $ bundle exec foreman start

Then, in a separate terminal window, start the Rails development server:

    $ bundle exec rails server

You can now navigate to the application at `http://localhost:3000`. You can also
access Solr at `http://localhost:8983/` and Fedora at `http://localhost:8984/`.

### Creating initial admin user and role

An administrative user needs to be created to access all the features of Sufia.
First, visit `http://localhost:3000/users/sign_in` and create an account. Next,
open a Rails console to set up admin access:

    $ bundle exec rails c
    > u = User.find_by_user_key("your_user_email@example.com")
    > u.admin = true
    > u.save

[1]: https://github.com/projecthydra/sufia
[2]: https://www.ruby-lang.org/en/
[3]: http://bundler.io
[4]: http://redis.io
[5]: http://www.imagemagick.org/script/index.php
[6]: http://projects.iq.harvard.edu/fits/
[7]: https://www.libreoffice.org
[8]: http://www.ghostscript.com/
[9]: https://www.handle.net/
[10]: http://phantomjs.org
[11]: http://brew.sh
[12]: https://github.com/postmodern/chruby
[13]: https://rvm.io
