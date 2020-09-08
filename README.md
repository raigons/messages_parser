[![Build Status](https://github.com/raigons/messages_parser/workflows/CI/badge.svg)](https://github.com/raigons/messages_parser/actions)

# MessagesParser
Parses exported messages from whatsapp in order to extract informations over conversations.
It is still very 'dumb' and got little functionalities.

## Installation

### Docker
To run you can execute two files to create the container, under `infra/scripts`, which are `build_local_container.sh` and
`build_and_get_int_iex.sh`. The latter connects directly into container's `iex`, the former run the container naming it `messages_parser` and and make it keep alive so you can iteract to the command line.

#### Executing reports
After running `build_local_container.sh` you can start interacting with it in order to get your reports. To do so you need to `source` a script located inside `commands/` folder, as following:

```sh
$ source commands/docker/reports.sh
```

This will provide you a command line program `report` which you can use to ask for the reports.
For now there is only one report which is count messages by users. You need to run this command as:

```sh
$ report -f ../path/to/file
```
where `-f` is the message file you want to parse. Report result that will be printed on your terminal.

### Local
Run, sequentially:

```sh
$ mix deps.get
$ iex -S mix
```

Running locally and getting into iex you can interact directly with the code, calling the modules inline. Or you can just execute the mix tasks related to the operation you want without connecting into `iex`

##### Inside iex:
```elixir
{:ok, record} = Reader.MessageReader.import(file_path)
Report.MessagesByUser.count(record)
```
##### executing mix task via your command lind:

```sh
$ mix report.messages_by_user "path/to/file.txt"
```
