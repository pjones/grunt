# Grunt

Grunt is a set of files for [GNU Make][] with some helper shell
scripts that assist a system administrator in the task of setting up
and maintaining Unix-like systems.  It's a very, very lightweight and
simple alternative to more complex systems like [Puppet] and [Chef].

Tasks that Grunt automates range from installing configuration files
maintained in a local [Git] repository to installing software and
restarting services after their configuration files change.

If you're comfortable with make files and shell scripts Grunt might be
the right tool for you.

# Why Does Grunt Exist?

I'm a software developer and I tend to create a lot of virtual
machines to test out different ideas and to ensure complete isolation
of client environments.  After experimenting with tools like [Puppet]
I decided I didn't really need so many features for these often
short-lived systems.

[Puppet] or [Chef] might actually be the right tool for you and I
suggest you look there first.

I'm a weirdo, I actually like writing make files and shell scripts and
prefer to know exactly what files are going to change and when.
That's why I wrote Grunt.

# Getting Started with Grunt

Grunt comes with a script to generate a skeleton [Git] repository and
set itself up as a submodule.

  1. Get a local copy of Grunt so you can run the skeleton script:

        git clone git://github.com/pjones/grunt

  2. Run the skeleton script.  It takes a single argument, the name of
     the directory you want to create for storing the skeleton files.
     This directory will become a new [Git] repository:

        grunt/bin/skel.sh mynewserver

     Optionally, `skel.sh` can take a second argument that should name
     a supported operating system.  This is useful when you are
     generating a skeleton on one operating system to be used for
     another:

        grunt/bin/skel.sh mynewserver debian

  3. Take a look at the files that were placed in the directory that
    `skel.sh` created.

  4. Go into each sub-directory and do a dry run to see what would get
     installed:

        (cd etc && make -Bn)

# Tips for Using Grunt

  1. Grunt comes with some default configuration files.  For example,
     it has a default `sshd_config` in `grunt/generic/etc`.  If you
     don't have a local copy in your `etc` (*not* `/etc`) directory
     then the Grunt provided version will be installed instead.

     To override Grunt's version of these configuration files simply
     place a file with the same name and your desired contents into
     your local directories.  When looking for a file to install into
     `/etc` Grunt will usually look for the file in this order:

       - `etc`
       - `grunt/<os>/etc`
       - `grunt/generic/etc`

  2. If you `scp` an existing Git repository to a new server it's best
     to update all the timestamps on these files before running
     `make`.  That way you know your copies of configuration files
     will get installed on a recently built system.  Use the following
     command to update all the timestamps:

        find . -type f -exec touch '{}' \;

# Technical Documentation

Grunt is split into several directories, one for each operating system
that it supports with an additional `generic` directory for files that
work on all supported operating systems.

Most of the operating system directories (and `generic`) have a
directory called `mk` where make files are stored.  Most of these make
files include simple descriptions of what they do.

Additionally, some of these operating system directories contain a
`README.md` file that provides an overview of what the make files and
shell scripts are used for and how to use them.

# Helping Out

Patches and pull requests are welcome.  Areas that might need some
work:

  * Improved documentation in the `*.mk` files.

  * Improved documentation in `README.md` files.

  * Improved skeleton files.

  * See the `TODO.org` file for more.

[gnu make]: http://www.gnu.org/software/make/
[git]: http://git-scm.com/
[puppet]: http://puppetlabs.com/
[chef]: http://www.opscode.com/chef/
