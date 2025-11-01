# Shell Scripting

This short guide explains what shell scripting is, why you might use it, and the basic concepts you should know to get started.

## What is shell scripting?

Shell scripting is the practice of writing a sequence of shell commands in a text file (a script) so they can be executed together by a shell (for example, Bash, sh, zsh). Shell scripts automate repetitive tasks, glue command-line tools together, and manage system operations on Unix-like systems.

## Why use shell scripts?

- Automate repetitive tasks (backups, deployments, builds).
- Orchestrate command-line tools and pipelines quickly.
- Create lightweight utilities without compiling code.
- Run scheduled jobs (cron) or boot-time tasks.

## Getting started (minimal contract)

- Inputs: command-line arguments, environment variables, files.
- Outputs: STDOUT/STDERR, exit status, files changed.
- Error modes: non-zero exit codes for failures; scripts should fail fast when appropriate.

Create a script file and add a shebang on the first line to indicate the interpreter:

```bash
#!/usr/bin/env bash
# Example: hello.sh
echo "Hello, world!"
```

Make it executable and run it:

```bash
chmod +x hello.sh
./hello.sh
# or
bash hello.sh
```

## Basic concepts and short examples

### 1) Variables

```bash
name="Alice"
echo "Hello, $name"
```

Notes: no spaces around `=`. Prefer quotes (`"$var"`) when expanding variables.

### 2) Quoting

- Double quotes: allow expansion but prevent word splitting (`"$var"`).
- Single quotes: literal strings, no expansion (`'text'`).
- Use `"$var"` to avoid surprising splits and globbing.

### 3) Command substitution

```bash
now=$(date +%F_%T)
echo "Now: $now"
```

### 4) Conditionals

```bash
if [[ -f /etc/passwd ]]; then
	echo "passwd exists"
else
	echo "no passwd"
fi
```

Use `[[ ... ]]` for safer, Bash-specific tests; `[` or `test` are POSIX-compatible alternatives.

### 5) Loops

```bash
for i in 1 2 3; do
	echo "Number $i"
done

while read -r line; do
	echo "Line: $line"
done < file.txt
```

### 6) Functions

```bash
greet() { echo "Hello, $1"; }
greet "Bob"
```

Functions return exit codes (use `return` or `exit` appropriately) and can print output.

### 7) Script arguments and common variables

- `$0`: script name
- `$1`, `$2`...: positional arguments
- `$#`: number of positional args
- `$@`: all positional args individually quoted
- `$?`: exit status of last command

Example:

```bash
if [[ $# -lt 1 ]]; then
	echo "Usage: $0 <name>" >&2
	exit 2
fi
```

### 8) Exit codes

Use `exit 0` for success; non-zero for various errors. Choose distinct codes for different failures when useful.

### 9) Permissions

Give scripts execute permission with `chmod +x script.sh`. When running from cron or systemd, ensure the file and any referenced files are accessible by the user that runs them.

## Safety, debugging and robustness

- For stricter error handling in many scripts, use at the top:

```bash
set -euo pipefail
```

- `-e` exits on error, `-u` treats unset variables as errors, `-o pipefail` causes pipelines to fail on the first failing command.
- For debugging, run with `bash -x script.sh` or add `set -x` to trace execution.
- Validate inputs and prefer absolute paths when running under cron or other non-interactive environments.

