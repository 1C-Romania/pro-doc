pro-doc
=======

This is a description of a product documentation technique.
This is not a complete automated solution, this is a method and a storage for some tools.
It's basically sphinx_ implementation.

Starting conditions
-------------------

* medium to small company
* 1 to 10 software products
* existing documentation looking like productNameManualV14.docx

Results
-------

* product documentation is edited via gitflow_
* product documentation is maintained and edited in reStructuredText_ (rst)
* maintainer builds html version of documentation and uploads it to website in "push button" mode
* each product can have separate documentation maintainer

Costs
-----

* setup
* build server
* users learn gitflow_
* users learn reStructuredText_

Method
------

For each product separate git repository is created and maintainer is chosen.
Anyone forks repo, edits and submits pull request to maintainer. Maintainer merges and pushes to build server.
Build server builds and uploads to webhost.

Dead simple, but there are always some details.

Convert existing documents to rst
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Useful tools: Pandoc_, Inkscape_.
Pandoc does all the heavy lifting while Inkscape (command line) is useful to batch convert images to desired format (usually png for web). 

Product manuals are usually pretty long, so it seems like a good idea to split them in chapters. Each chapter in a separate file.
Small files are easier to view and edit, easier to build website from and easier to create links to.
Sample bash scripts to do so: split.sh_, fetchLinks.sh_.

Public repositories
~~~~~~~~~~~~~~~~~~~

Gitflow requires everyone to have a "public" repo to collaborate.
There is no reason not to use github so everyone has to have an account and if for some reason you need privacy you can create a paid private repo.

Build server
~~~~~~~~~~~~

It seems like good idea to have a web server on the build server. 
You can test things like custom css or web server configuration with it.

For each product:

* a user is created as productName-doc
* git repo is cloned in home directory
* special "bare_" branch is created
* sphinx_ is initialized 
* index.rst is populated with chapter files
* BUILDDIR in sphinx_'s Makefile is redirected to /var/www/html/productName-doc
* permissions for the new user and web server are set up
* ssh keys are installed: maintainer's public key on the build server and build server's public key on the webhost
* "bare" branch is checked out
* git hook_ is created

.. _bare: 

**Bare branch hack**

Normally you should only git push to a `bare repository`_. 
Bare repository contains only .git folder and does not have the files, which we need to build from. 
It is possible to push to a non-bare repo though, but only to a branch that is not currently checked out.
So we create a special branch, say "bare", which will always be checked out, then, when we need to build, we checkout the branch conaining actual files, build and checkout "bare" back.
Why hack? It's a hack inside, but pretty usable outside.
Since maintainer already uses git to manage documentation it is hard to imagine simpler interface for them then "git push build" ("build" being build server added as a remote).
And if you use non-bare repository you can then build via dead simple git hook.

Web server config
~~~~~~~~~~~~~~~~~

Sphinx will create "html" subdirectory when building, so it seems pretty to add a redirect.

For apache something like this:

  Redirect permanent "/productName-doc/index.html" "/productName-doc/html/index.html"

.. _sphinx: http://www.sphinx-doc.org/en/stable/index.html
.. _reStructuredText: http://docutils.sourceforge.net/docs/user/rst/quickref.html
.. _gitflow: https://git-scm.com/book/en/v2/Distributed-Git-Distributed-Workflows
.. _Pandoc: http://pandoc.org/
.. _Inkscape: https://inkscape.org/en/
.. _split.sh:
.. _fetchLinks.sh:
.. _`bare repository`: https://git-scm.com/book/en/v2/Git-on-the-Server-The-Protocols
.. _hook:
