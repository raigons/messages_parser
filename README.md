[![Build Status](https://github.com/raigons/messages_parser/workflows/CI/badge.svg)](https://github.com/raigons/messages_parser/actions)

# MessagesParser
Parses exported messages from whatsapp in order to extract informations over conversations.
It is still very simple  and got little functionalities.

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
For now there is only two reports: count messages by users and count messages per day. You need to run this command as:

```sh
$ report -f ../path/to/file -r messages_by_user
```
where `-f` is the message file you want to parse and `-r` is the report report name. Report result that will be printed on your terminal.

If you need to see a list of the available reports, run:

```sh
$ report -h
```

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
# %{"John Doe" => 10, "Someone" => 8}

{:ok, record} = Reader.MessageReader.import(file_path)
Report.MesssagesPerDay.count(record)
#%{
#  ~D[2020-06-07] => 29,
#  ~D[2020-02-06] => 69,
#}
```

##### executing mix task via your command lind:

```sh
$ mix report.messages_by_user "path/to/file.txt"
```

```sh
$ mix report.messages_per_day "path/to/file.txt"
```
