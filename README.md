# A CLI Countdown Timer that rings an alarm after a certain time.

## Install:

Download the binaries from the releases section according to your operating system

Put your desired ringtone as `~/tones/play.mp3`.

## Features:

- Can be used to query past activities
- Can play just about any song. Ultimately it uses the system music player

## Commands:

1. `start <time_in_minutes>`

   Sets the countdown timer in motion for _time_in_minutes_

2. `delete <entry_id> | *`

   i. To delete all the entries type in `delete all`

   ii. To delete a particular entry with id: `<entry_id>`, type in `delete <entry_id>`

3. `update <entry_id>,<new_start_time>,<new_end_time>`

   Update a certain entry with `<entry_id>` where the new start time is `<new_start_time>` and the new end time is `<new_end_time>`

4. `get * | <unix_time>`

   a. Get all the entries that have been entried upon after a particular `<unix_time>`. Use `get <unix_time>`. e.g. `get 16450003300`
   b. Get all the entries by using `get *`

5. `stop` - (not implemented yet)

   Stops the timer.

6. `help` - open the help menu

7. `exit` - exit the countdown timer

8. `cls` | `clear` - clear the screen


## Develop:

## ROADMAP:

- [ ] Add direct CLI commands.
- [ ] Seggregrate more clearly the APIs so that UI component can be separated from the business logic.
- [ ] Put more font styles similar to Cordless Discord
- [ ] Play audio controls to the UI.
- [ ] Implement a RPC server for the business logic in a separate thread instead of using direct binary communication.