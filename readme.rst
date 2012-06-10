Makefile
---------
- Do something once, ugh fine, do it a second time...script it and automate
  it.
- Makefile
- Let's start out doing some things.
- Rules engine
- Smart one though, it pays attention to things.
- Two main parts

  - something you want
  - what that something requires (dependencies)
  - how to make that something

- Let's create our first makefile rule. We need git for stuff to work.

  - we want the file /usr/bin/git
  - it depends on nothing, first we've got
  - in order to make /usr/bin/git, we install the git package


:Note:

    syntax, item colon deps, hard tab (no spaces here)
    make $something runs that makefile section
    first item in your make file is run by default with make

- We run the make command a second time, note that it's skipped, /usr/bin/git
  exists and there's no dependencies that say we need to change things.

Clean
-----
- Add a clean command, make it dep on clean-git

  - clean doesn't need to do anything, it's just a target
  - Neither of these actually depend on targets on disk, they're PHONY
    commands. Introduce .PHONY
  - Opposite is to uninstall

Ok, so this isn't all that impressive, let's add something else. Once we have
git installed, we want to use it to pull down something. Let's grab this talk.

- git clone https://github.com/mitechie/mugtalk_make_2012.git

  - note that it's going to have to depend on git being there
  - let's make this the first target
  - we added something, let's clean it up by removing the directory

- now we make clean && make and see that it goes ahead, gets git, and then
  clones the repo. Note that we didn't tell it to install git, it's a dep

- so that's great, but let's make it more useful. What if you could get this
  talk in html format. We'd need to generate the html file from the .rst file
  in the git repo.

- So we need to easy_install rst2html python tool to install a python package
  we need easy_install command

  - /usr/local/bin/rst2html and /usr/local/bin/easy_install
  - package name is docutils
  - setup .PHONY html command -- this is getting messy
  - Make supports the use of variables, let's define some to make our life
    easier

Variables
----------

- 2 types

  - single pass, think constants :=
  - multiple pass =

- $(var) is the format for variables you define
    change the paths into variables

So finish up the html command to use those variables, add all three deps, and
output the nice command for us

::

    rst2html mugtalk_make_2012/readme.rst > mugtalk.html

We're generating something, let's make sure we clean it up.

:Note:
That this is a good reason why we don't just make an all powerful clean
command, but different ones. Let's say we update the readme, and want to
regenerate the html. There's on reason to reinstall all the deps in order to
do so, we can just run make clean-html

So cool, now if I give you this makefile, download it from a website, you can
run a single command `make html` and generate an up to date html file right
off the bat, but hey, let's make this easier for users. If we're generating an
html file, let's just open the dippy thing in their browser for them.

Generic: xdg-open
------------------

Makefiles are meant to be generic, work on many systems, so we shouldn't just
use firefox, chrome, etc...xdg-open is a tool for opening in the user's
default tool.

Let's add an open command, `xdg-open mugtalk.html`

Cool, but like all code we should refactor. We've got some duplication here in
the mugtalk.html output file. Let's variable-ize it.

Ok, let's try this out.

Now this is interesting, but notice that each time we run `make html` it's
repeating the task, even though there's no need. The rst file hasn't changed.
It's not like the git commands because it's a PHONY command. Let's actually
use the rst file as an INPUT file and the html file as the OUTPUT file.

Now let's update all our commands, INPUT is created by it's dependencies

OUTPUT is created by processing input.

If we run the make open, it does all the work we need and opens the file. If
we run it a second time, there's nothing to do. It's all peachy.

Now let's say we edit the input file, the rst file, and rerun make open. What
happens? Now it reruns the rst2html on the updated readme.rst file.

What's cool here is that Make is only doing the work that needs to be done,
only changing files that need to be changed. Let's say we remove the git
checkout and rerun make open, notice that it doesn't redownload any deps, it
only re-clones the repository, that's the only thing that's missing.

So now you're starting to see some of the cool powerful bits of Make, and
notice this is a pretty simple case, built step by step.


JS Min
-------

Side trip, dep cleanup
~~~~~~~~~~~~~~~~~~~~~~~
- We've got a series of JS files, we want to minify and concat them to build
- We need a minifier
- easy_install lpjsmin /usr/local/bin/lpjsmin

- reorg this to deps-python
- downside, this will always run, even if installed
- cleaner and not that expensive
- Let's use define to generate the list of deps so we can share that list among install/uninstall

- Notice that it's a bunch of newlines, we can use the build int $(strip) to
  turn that into a proper list on the command line


Back to our quest
~~~~~~~~~~~~~~~~~~~
- dir of js files, let's first create a variable list of them. (using wildcard
  function)
- we want to have a build dir for our JS files (using $@ for our target)
- we also want the build version of our js files (using pathsubst function)
  - and build with $< which is the path of our first pre-req (our only case)
- finally, we want a .min version of our js files

- this is great, but sucks to have to run `make jsmin` every time we change a
  files
- Python tool: watchdog to run a command every time a file changes, we already
  have a command to run: `make jsmin`
- Add jsauto command that needs new dep watchdog, rnus watchmedo on the
  original js directory, and auto builds for us. Notice how if we change a
  file, the make jsmin kicks it

  - jsmin required BUILD_JSFILES
  - those come from the cp command so they're copied
  - and jsmin re-mins the updated build directory

- The lpjsmin isn't smart enough to not min already min files, so let's remove
  them, but they might not exist, so we can ignore failures silently with the
  `-`. This is a good fit for our -f check in clean-html so let's add it there
  as well.


Magic Variables:
-----------------
There are seven “core” automatic variables:
- $@ The filename representing the target.
- $% The filename element of an archive member specification.
- $< The filename of the first prerequisite.
- $? The names of all prerequisites that are newer than the target, separated by spaces.
- $^ The filenames of all the prerequisites, separated by spaces. This list
  has duplicate filenames removed since for most uses, such as compiling,
  copying, etc., duplicates are not wanted.
- $+ Similar to $^, this is the names of all the prerequisites separated by
  spaces, except that $+ includes duplicates. This variable was created for
  specific situa-tions such as arguments to linkers where duplicate values
  have meaning.
- $* The stem of the target filename. A stem is typically a filename without
  its suffix.  (We’ll discuss how stems are computed later in the section
  “Pattern Rules.”) Its use outside of pattern rules is discouraged.


Other Makefiles
---------------

- https://github.com/mitechie/breadability/blob/master/Makefile
- https://github.com/mitechie/bookie_parser/blob/master/Makefile

Final thoughts
---------------

- Automate!
- New users <3 this stuff
- Make life easier for everyone
- Great for build steps/stuff.
- Managing project with GNU Make is a great book, get it.
