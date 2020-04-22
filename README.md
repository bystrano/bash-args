Bash-args
=========

This is a framework for writing bash scripts that accept options and/or
arguments. The options and arguments accepted by your script are defined in the
first comment block using a simple declarative syntax. _bash-args_ uses these
metadata to:

- Parse the command arguments
- Generate help pages
- Setup auto-completion

It is designed to be simple to use, to get out of the way, and to provide a
polished CLI UX.

It aims to be widely compatible, the test suite passes on all major versions of
bash >= 3.2.


Quickstart
----------

To use _bash-args_ in your scripts, simply source `init.sh` before doing
anything.

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

_Bash-args_ provides a mecanism to define sub-commands. To use it, you need to
call the `cmd_run` function at the end of your main script. You can then define
subcommands by adding files in a special `cmd/` directory. Your project's
structure should look like :

```
main-script.sh
cmd/
  - subcmd1.sh
  - subcmd2.sh
```

You can then write metadatas in the first comment blocks of the subcommands,
just like in the main script. It allows you to document, and define the options
and arguments of the subcommands.

The options defined in the main script are valid for all subcommands, while
options defined in a subcommand are specific to this subcommand.

Following this structure gives you the following features :

- The subcommands are listed in the main commands' help.
- You can get a help page for a specific command by typing `main-script.sh help
  subcmd1`, or `main-script.sh subcmd1 --help`.
- Auto-completion for the subcommands and their options and arguments.
