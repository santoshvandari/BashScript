# Crontab (cron jobs)

Short, practical reference for creating and managing cron jobs on Linux.

## Purpose

This README explains the most commonly used crontab commands, the line format, quick examples, debugging tips, and common pitfalls — focused on developers and ops engineers who need to schedule tasks reliably.

## Quick commands

- List current user's cron jobs:

```bash
crontab -l
```

- Edit current user's crontab (opens $EDITOR):

```bash
crontab -e
```

- Remove current user's crontab:

```bash
crontab -r
```

- Edit system-wide crontab (needs root):

```bash
sudo nano /etc/crontab
# or
sudo crontab -e -u root
```

- List system cron directories:

```bash
ls -l /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d
```

- Restart cron service (if you changed system cron files):

```bash
# Debian/Ubuntu
sudo systemctl restart cron

# RHEL/CentOS
sudo systemctl restart crond
```

## Crontab line format

Each non-comment line in a crontab has 6 fields:

```
MIN HOUR DOM MON DOW COMMAND
```

- MIN: 0-59
- HOUR: 0-23
- DOM (day of month): 1-31
- MON (month): 1-12
- DOW (day of week): 0-7 (0 and 7 = Sunday)
- COMMAND: shell command or script to run

Examples of common patterns:

- Run every minute: `* * * * * cmd`
- Run at 2:30am daily: `30 2 * * * cmd`
- Run at 5pm on weekdays: `0 17 * * 1-5 cmd`
- Run on the 1st of every month at midnight: `0 0 1 * * cmd`

Special strings (shortcuts):

- `@reboot` — run once at boot
- `@yearly` / `@annually` — run once a year
- `@monthly` / `@weekly` / `@daily` / `@hourly`

Example using a special string:

```
@daily /usr/local/bin/daily-maintenance.sh
```

## Practical examples

- Log disk usage every day at 6am:

```
0 6 * * * /usr/bin/du -sh /var/log > /var/log/disk-usage-$(date +\%F).txt 2>&1
```

- Rotate logs using a script every Sunday at 3:30am:

```
30 3 * * 0 /home/deploy/scripts/rotate-logs.sh >> /var/log/cron-rotate.log 2>&1
```

- Run a job as another user (system crontab or sudo):

In `/etc/crontab` and files in `/etc/cron.d/` the format includes a user field:

```
# MIN HOUR DOM MON DOW USER  COMMAND
0 4 * * * root /usr/local/bin/system-backup
```

## Environment & paths

Cron runs with a minimal environment. Important notes:

- Always use full paths for executables and files.
- Set `PATH` at top of crontab if needed:

```
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

- Use `MAILTO` to receive stderr/stdout by email (if mail is configured):

```
MAILTO=devops@example.com
```

Or redirect output to log files (`>> /path/to/log 2>&1`).

## Debugging & tips

- If a job doesn't run:

  - Check `/var/log/cron` or system journal: `journalctl -u cron` (or `crond`).
  - Redirect stdout/stderr to a file to capture errors.
  - Test the command manually as the target user.

- Use a simple shell wrapper script to set env, then call heavy commands. This simplifies debugging and keeps the crontab readable.

- When editing with `crontab -e`, the file is syntax-checked by cron on save; a bad line may be ignored.

## Common pitfalls

- Relative paths: always use absolute paths.

# Crontab (cron jobs)

Short, practical reference for creating and managing cron jobs on Linux.

## Purpose

This README explains the most commonly used crontab commands, the line format, quick examples, debugging tips, and common pitfalls — focused on developers and ops engineers who need to schedule tasks reliably.

## Quick commands

- List current user's cron jobs:

```bash
crontab -l
```

- Edit current user's crontab (opens $EDITOR):

```bash
crontab -e
```

- Remove current user's crontab:

```bash
crontab -r
```

- Edit system-wide crontab (needs root):

```bash
sudo nano /etc/crontab
# or
sudo crontab -e -u root
```

- List system cron directories:

```bash
ls -l /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d
```

- Restart cron service (if you changed system cron files):

```bash
# Debian/Ubuntu
sudo systemctl restart cron

# RHEL/CentOS
sudo systemctl restart crond
```

## Crontab line format

Each non-comment line in a crontab has 6 fields:

```
MIN HOUR DOM MON DOW COMMAND
```

- MIN: 0-59
- HOUR: 0-23
- DOM (day of month): 1-31
- MON (month): 1-12
- DOW (day of week): 0-7 (0 and 7 = Sunday)
- COMMAND: shell command or script to run

Examples of common patterns:

- Run every minute: `* * * * * cmd`
- Run at 2:30am daily: `30 2 * * * cmd`
- Run at 5pm on weekdays: `0 17 * * 1-5 cmd`
- Run on the 1st of every month at midnight: `0 0 1 * * cmd`

Special strings (shortcuts):

- `@reboot` — run once at boot
- `@yearly` / `@annually` — run once a year
- `@monthly` / `@weekly` / `@daily` / `@hourly`

Example using a special string:

```
@daily /usr/local/bin/daily-maintenance.sh
```

## Practical examples

- Log disk usage every day at 6am:

```
0 6 * * * /usr/bin/du -sh /var/log > /var/log/disk-usage-$(date +\%F).txt 2>&1
```

- Rotate logs using a script every Sunday at 3:30am:

```
30 3 * * 0 /home/deploy/scripts/rotate-logs.sh >> /var/log/cron-rotate.log 2>&1
```

- Run a job as another user (system crontab or sudo):

In `/etc/crontab` and files in `/etc/cron.d/` the format includes a user field:

```
# MIN HOUR DOM MON DOW USER  COMMAND
0 4 * * * root /usr/local/bin/system-backup
```

## Environment & paths

Cron runs with a minimal environment. Important notes:

- Always use full paths for executables and files.
- Set `PATH` at top of crontab if needed:

```
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

- Use `MAILTO` to receive stderr/stdout by email (if mail is configured):

```
MAILTO=devops@example.com
```

Or redirect output to log files (`>> /path/to/log 2>&1`).

## Debugging & tips

- If a job doesn't run:

  - Check `/var/log/cron` or system journal: `journalctl -u cron` (or `crond`).
  - Redirect stdout/stderr to a file to capture errors.
  - Test the command manually as the target user.

- Use a simple shell wrapper script to set env, then call heavy commands. This simplifies debugging and keeps the crontab readable.

- When editing with `crontab -e`, the file is syntax-checked by cron on save; a bad line may be ignored.

## Common pitfalls

- Relative paths: always use absolute paths.
- Relying on interactive features: cron runs non-interactively.
- Long-running tasks: ensure they don't overlap; consider lockfiles or `flock`.
- Quoting and percent (%) characters: `%` is treated specially by cron (it becomes newline in command); escape with `\%`.

## Developer checklist (mini contract)

- Inputs: a shell command or script path and the desired schedule.
- Output: scheduled execution by cron; logs if redirected or mailed via `MAILTO`.
- Error modes: cron silently drops malformed lines; check logs and `crontab -l`.

Edge cases to consider: empty PATH, permissions, SELinux/AppArmor, user-specific vs system crontabs, daylight saving/time zone changes.

## Try it — minimal quick tests

1. Add a test job for your user that writes a timestamp every minute:

```bash
(crontab -l 2>/dev/null; echo "* * * * * /bin/date >> $HOME/cron-test.log 2>&1") | crontab -
```

2. Wait a minute, then inspect `~/cron-test.log`.

3. Remove the test job:

```bash
crontab -l | grep -v 'cron-test.log' | crontab -
```

## Example

- Create a Simple Script
  We will create a simple bash script that logs the current date and time to a file.

```bash
#!/bin/bash
echo "Current date and time: $(date)" >> ./cron-test.log
```

- Make the script executable:

```bash
chmod +x /home/user/scripts/cron-test.sh
```

- Add the cron job to run the script every minute:

```bash
crontab -e
```

- Add the following line to the crontab file:

```bash
* * * * * /home/user/scripts/cron-test.sh >> /home/user/scripts/cron-test.log 2>&1 # cron-test
```

Here, \* \* \* \* \* means the script will run every minute. The output (both stdout and stderr) is appended to cron-test.log. The first is for minutes, the second for hours, the third for day of the month, the fourth for month, and the fifth for day of the week.

- Save and exit the editor. The cron job is now scheduled.

## Cleanup

To remove the cron job, you can edit the crontab again:

```bash
crontab -e
```

Then delete the line you added for the cron job or use the following command to remove it directly

````bash
crontab -l | grep -v -F '# cron-test' | crontab
````
