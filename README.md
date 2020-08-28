# MessagesParser
Parses exported messages from whatsapp in order to extract informations over conversations.
It is still very 'dumb' and got little functionalities.

## Installation

### Docker
To run you can execute two files to create the container, under `infra/scripts`, which are `build_local_container.sh` and
`build_and_get_int_iex.sh`. THe former just run the container and connect to its shell, latter connect direct into container `iex`

### Local
Run, sequentially:

```shell
$ mix deps.get
$ iex -S mix
```
