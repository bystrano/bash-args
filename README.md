Bash-args
=========

This is a framework for writing bash scripts that accept options and/or
arguments. Define the options and arguments accepted by your script using a
simple declarative syntax and let _bash-args_:

- Parse the command arguments
- Generate help pages
- Handle auto-completion

It is designed to be simple to use, to get out of the way, and to provide a
polished user experience.

It aims to be portable, the test suite passes on all major versions of
bash >= 3.2.


Table of contents
----------

- [Quick start](#quick-start)
  - [Sub-Commands](#sub-commands)
- [Script metadata](#script-metadata)
- [Defining options](#defining-options)
- [Auto-completion](#auto-completion)
  - [Argument types](#argument-types)
  - [custom argument types](#custom-argument-types)


Quick start
----------

To use _bash-args_ in your scripts, simply source the `init.sh` file.

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

. path/to/bash-args/init.sh

# After sourcing the script, you can use the $directory and the $dry_run
# variables to get the values of the options typed (or not) in the command line.
# The other arguments are available as standard bash arguments $1, $2, etc.

command="cd $directory && $1"

if [[ $dry_run -eq 1 ]]; then
    echo "$command"
else
    eval "$command"
fi
```

Let's try to run this command with options :

```
$ eval-command.sh --dry-run --directory /home 'echo hello'
cd /home && echo hello
```

You can use short options, and they can be grouped :

```
$ eval-command.sh -nd /home 'echo hello'
cd /home && echo hello
```

Setup tab completion with a simple command :

```
$ eval $(eval-command.sh _register_completion)
```

A help page is provided :

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


### Sub-Commands ###

_Bash-args_ can also manage sub-commands :

- Help pages are available for each command using `main-script.sh help subcmd1`,
  or `main-script.sh subcmd1 --help`.
- Auto-completion suggest sub-commands, their options and their arguments.

To make this happen, call the `cmd_run` function at the end of your main script,
and define sub-commands by adding shell scripts to the `cmd/` directory. Your
project's structure should look like :

```
main-script.sh
cmd/
  - subcmd1.sh
  - subcmd2.sh
```

To document the sub-commands, and define their options and arguments, write
metadata in the first comment blocks of each sub-command, just like in the main
script.

Options defined in the main script are available to all sub-commands, while
options defined in a sub-command are only available to this specific
sub-command.


Script metadata
-------------

The script metadata follow a very simple syntax: in the first comment block,
each line that starts with a word followed by a semi-colon defines a new field,
and everything that follows the semi-colon defines its value. The following
lines, up to the next field start, are appended to the value.

Here are the fields used by *bash-args*.

- **Summary :** A one line description of the script.
- **Description :** A long description of the script.
- **Version :** A version string. If your main script has a version meta field,
  it will get a `--version` option that prints its name and version.
- **Usage :** If the default usage line in the help page doesn't suit you, you
  can override it here.
- **Argument :** Defines the argument type used for auto-completion.
  see [Argument types](#argument-types)
- **Options :** Define the options of your script.
  see [Defining options](#defining-options)


Defining options
----------------

The options are defined in the *Options* metadata, like in the example script :

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
alpha-numeric characters, `_` or `-`.

The following lines define the option's parameters. When the script is run, this
is actually eval'd as bash code. The variables defined are the option's
parameters. This means that the general quoting rules for strings apply, and
that you can define the options dynamically, like in the example above, in which
the `default` parameter of the `directory` option is set to `$(pwd)`.

An option *must* define at least the `type` and `variable` parameter :

- `type` can be either `flag` or `option`. Flags don't accept arguments, options
  do.
- `variable` is the variable name under which the option's argument value will
  be available in your script.

An option *may* define these other parameters :

- `desc` is a description of the option, used in the help pages.
- `short` is a single letter, used for the short option.
- `argument` is the argument type. see [Argument types](#argument-types)
- `default` is the value the option takes when the option is not specified in
  the command typed by the user.
- `value` is the value the option takes when the option *is* specified, but
  without argument.

The variables defined by options are guaranteed to be defined in your script :
if *bash-args* can't find a value for an option, it will exit with an error.
This means that if you don't specify an option's `default`, running the main
script without this option will return an error.

In other words, if you don't want an option to be required, define a `default`
parameter in its definition.

The `value` parameter works in a similar way. If you don't specify it, the
option, when used, requires an argument. If you do, the option can be used
without argument.

Flag options work the same way, and since they don't take arguments, you must
define both their `default` and `value` parameters.


Auto-completion
---------------

*Bash-args* can handle auto-completion for your script using Bash's completion
API. To activate auto-completion for your command run the following command :

```bash
eval $(my-command.sh _register_completion)
```

Tab-completion will then suggest the defined options if the word at point starts
with an `-`, and suggest sub-commands and arguments otherwise.


### Argument types ###

To tell *bash-args* what to suggest as an argument, you specify an *argument
type* in the `Argument` metadata of your script (or sub-command), or in the
`argument` parameter of an option.

Here are the built-in argument types :

- **file** will suggest files.
- **directory** will suggest directories.


### Custom argument types ###

To create a new argument type and set it up for auto-completion, define a
function called `_complete_my_arg_type`. This function must be available to the
`init.sh` script, so it has to be defined *before* the `. init.sh` line.

The completion functions are supposed to add their suggestions to the global
`COMP_REPLIES` array. They get the current word at point as parameter for
convenience, but you can also use the `COMP_LINE` and `COMP_POINT` global
variables, just like in all bash completion scripts.

Here is how the **file** argument type is defined :

```bash
_complete_file () {

    # $1 is the word being typed that we want to complete.
    for file in "${1-}"*; do
        # add each file to the completion candidates.
        COMP_REPLIES+=("$file")
    done
}
```
