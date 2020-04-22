Bash-args
=========

This is a framework for writing bash scripts that accept options and/or
arguments. Define the options and arguments accepted by your script using a
simple declarative syntax and let _bash-args_:

- Parse the command arguments
- Generate help pages
- Setup auto-completion

It is designed to be simple to use, to get out of the way, and to provide a
polished CLI UX.

It aims to be widely compatible, the test suite passes on all major versions of
bash >= 3.2.


Table of contents
----------

- [Quickstart](#quickstart)
  - [Subcommands](#subcommands)
- [Script metadatas](#script-metadatas)
- [Defining options](#defining-options)
- [Auto-completion](#auto-completion)
  - [Argument types](#argument-types)
  - [custom argument types](#custom-argument-types)


Quickstart
----------

To use _bash-args_ in your scripts, simply source `init.sh`.

Here is an example script `eval-command.sh` :

```bash
#!/usr/bin/env bash
# Summary : My first bash script using bash-args.
#
# Description : This takes a command as argument, and runs it.
#
# Argument : command
#
# Options :
#
# % dry-run
# desc="Don't execute, just print."
# short="n" type="flag" variable="dry_run" value=1 default=0
#
# % directory
# desc="The directory in which to run the command." argument=directory
# short="d" type="option" variable="directory" default="$(pwd)"
#

# source bash-args' init script
. path/to/bash-args/init.sh

# After sourcing the script, you can use the $directory and the $dry_run
# variables to get the options passed (or not) in the command line.
command="cd $directory && $1"

if [[ $dry_run -eq 1 ]]; then
    echo "$command"
else
    eval "$command"
fi
```

That's it, you can now run your command with options :

```
$ eval-command.sh 'echo hello' -n --directory /home
cd /home && echo hello
```

The `$1` variable is set to the first argument that is not an option, even if it
didn't come first in the CLI.

```
$ eval-command.sh --dry-run --directory /home 'echo hello'
cd /home && echo hello
```
Short options can be grouped :

```
$ eval-command.sh -nd /home 'echo hello'
cd /home && echo hello
```

You can setup auto-completion with a simple command (that should probably be
copied into some init file) :

```
$ eval $(eval-command.sh _register_autocomplete)
```

A help page is generated automatically :

```
$ eval-command.sh --help
My first bash script using bash-args.

Usage : eval-command.sh [OPTIONS] [COMMAND]

This takes a command as argument, and runs it.

Options :

  --help | -h
          Show this help.

  --dry-run | -n
          Don't execute, just print.

  --directory | -d [DIRECTORY]
          The directory in which to run the command.
```


### Subcommands ###

_Bash-args_ provides a mecanism to define sub-commands that gives you the
following features :

- The subcommands are listed in the main commands' help.
- You can get a help page for a specific command by typing `main-script.sh help
  subcmd1`, or `main-script.sh subcmd1 --help`.
- Auto-completion for the subcommands and their options and arguments.

First, you need to call the `cmd_run` function at the end of your main script.

Then, you define your subcommands by adding files in a special `cmd/` directory.
Your project's structure should look like :

```
main-script.sh
cmd/
  - subcmd1.sh
  - subcmd2.sh
```

To document, and define the options and arguments of the subcommands, simply
write metadatas in the first comment blocks of the subcommands, just like in the
main script.

The options defined in the main script are valid for all subcommands, while
options defined in a subcommand are specific to this subcommand.


Script metadatas
-------------

The script metadatas follow a very simple syntax: in the first comment block,
each line that starts with a word followed by a semi-colon defines a new field,
and everything that follows the semi-colon defines its value. The following
lines, up to the next field start, are appended to the value.

Here are the fields you can use to document your scripts. They are used to
generate the help pages.

- **Summary :** A one line description of the script.
- **Description :** A long description of the script.
- **Version :** A version string. If your main script has a version meta field, it
  will automatically be added the --version option that prints its name and
  version.
- **Usage :** If the automatically generated usage line in the help page doesn't
  suit you, you can specify it here.
- **Argument :** Defines the argument type for auto-completion. see [Argument types](#argument-types)
- **Options :** Define the options of your script. see [Defining options](#defining-options)


Defining options
----------------

The options are defined in the *Options* metadata, like shown in the example
script :

```bash
# Options :
#
# % dry-run
# desc="Don't execute, just print."
# short="n" type="flag" variable="dry_run" value=1 default=0
#
# % directory
# desc="The directory in which to run the command." argument=directory
# short="d" type="option" variable="directory" default="$(pwd)"
#
```

An option starts with a `%` followed by its name. Option names must contain only
alpha-numeric characters, or `_` or `-`.

The following lines define the option's parameter. When the script is run, this
is actually eval'd as bash code. The variables defined are the option's
parameters. This means that the general quoting rules for strings apply, and
that you can define the options dynamically, like in the example above, setting
the `default` parameter of the `directory` option to `$(pwd)`.

An option *must* define at least the `type` and `variable` parameter :

- `type` can be either `flag` or `option`. Flags don't accept arguments, options
  do.
- `variable` is the variable name under which the option's argument value will
  be available in your script.

An option *may* define these other parameters :

- `desc` is a description of the option, used in the help pages.
- `short` is a single letter used for the short option syntax.
- `argument` is the argument type. see [Argument types](#argument-types)
- `default` is the value the option takes when the option is not specified in
  the command typed by the user.
- `value` is the value the option takes when the option *is* specified, but
  without argument.

The variables defined by options must always be defined, no matter what. This
means that if you don't specify an option's `default`, running the main script
without this option will return an error.

In other words, if you want an option to be required, omit the `default`
parameter in its definition.

The `default` parameter works in a similar way. If you don't specify it, the
option, when used, requires an argument. If you do, the option can be used
without argument.

Flag options work the same way, but since they don't take arguments, you must
define both their `default` and `value` parameters.


Auto-completion
---------------

### Argument types ###

### Custom argument types ###

