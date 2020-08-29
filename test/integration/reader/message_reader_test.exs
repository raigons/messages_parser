defmodule Reader.MessageReaderTest do
  use ExUnit.Case, async: false
  use Agent

  alias Reader.MessageReader

  describe "import simple line messages" do
    test "loads single message from file and parse it" do
      file_name = "test/fixtures/sample_1.txt"

      {:ok, record} = MessageReader.import(file_name)

      expected_message = %Message{
        author: "John Doe",
        datetime: ~N[2020-08-11 02:16:21],
        content: "Olá!"
      }

      assert %{
               "John Doe" => [expected_message]
             } == Agent.get(record, fn state -> state end)
    end

    test "loads multiples messages from file for same author" do
      file_name = "test/fixtures/sample_2.txt"

      {:ok, record} = MessageReader.import(file_name)

      expected_messages = [
        %Message{
          author: "Ramon",
          content: "Hi!",
          datetime: ~N[2020-08-25 02:16:21]
        },
        %Message{
          author: "Ramon",
          content: "Another message",
          datetime: ~N[2020-08-25 02:16:34]
        },
        %Message{
          author: "Ramon",
          content: "Plus one",
          datetime: ~N[2020-08-25 02:17:22]
        }
      ]

      assert %{
               "Ramon" => expected_messages
             } == Agent.get(record, fn state -> state end)
    end

    test "loads multiples messages for different authors" do
      file_name = "test/fixtures/sample_3.txt"

      {:ok, record} = MessageReader.import(file_name)

      john_messages = [
        %Message{
          author: "John Doe",
          datetime: ~N[2020-08-25 02:16:21],
          content: "Olá!"
        },
        %Message{
          author: "John Doe",
          content: "Some another message",
          datetime: ~N[2020-08-25 03:59:50]
        }
      ]

      ramon_messages = [
        %Message{
          author: "Ramon",
          content: "Hi!",
          datetime: ~N[2020-08-25 02:16:21]
        },
        %Message{
          author: "Ramon",
          content: "Another message",
          datetime: ~N[2020-08-25 02:16:34]
        }
      ]

      assert %{
               "John Doe" => john_messages,
               "Ramon" => ramon_messages
             } == Agent.get(record, fn messages -> messages end)
    end
  end

  describe "import multiple lines messages" do
    test "splits one multiline messages into one record per line with same datetime" do
      file_name = "test/fixtures/sample_4.txt"

      ramon_messages = [
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content:
            "Galera hoje esta rolando a votação da lei para legalização do cultivo caseiro de cannabis no Brasil para uso terapêutico e pessoal !!!"
        },
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content:
            "Vamos apoiar a causa , corre lá , faz seu cadastro , confirma o e-mail e vota vota vota !!!!!!!"
        },
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content: "💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀"
        },
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content: "A união faz a força !!!!!"
        },
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content: "https://www12.senado.leg.br/ecidadania/visualizacaomateria?id=132047"
        },
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content: "Não deixem de votar !!! E muito importante mesmo !!!!!!!!!!"
        }
      ]

      {:ok, record} = MessageReader.import(file_name)

      assert %{
               "Ramon" => ramon_messages
             } == Agent.get(record, fn messages -> messages end)
    end

    test "parses multiline messages inside a list of messages and keep parsing normally after" do
      file_name = "test/fixtures/sample_5.txt"

      john_messages = [
        %Message{
          author: "John Doe",
          datetime: ~N[2018-05-15 08:43:11],
          content: "Hello ma friend!"
        },
        %Message{
          author: "John Doe",
          datetime: ~N[2018-05-15 09:34:13],
          content: "fuckin 4:20"
        },
        %Message{
          author: "John Doe",
          datetime: ~N[2018-05-15 09:34:14],
          content: "ouch"
        }
      ]

      ramon_messages = [
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content:
            "Galera hoje esta rolando a votação da lei para legalização do cultivo caseiro de cannabis no Brasil para uso terapêutico e pessoal !!!"
        },
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content:
            "Vamos apoiar a causa , corre lá , faz seu cadastro , confirma o e-mail e vota vota vota !!!!!!!"
        },
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content: "💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀"
        },
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content: "A união faz a força !!!!!"
        },
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content: "https://www12.senado.leg.br/ecidadania/visualizacaomateria?id=132047"
        },
        %Message{
          author: "Ramon",
          datetime: ~N[2018-05-15 09:18:43],
          content: "Não deixem de votar !!! E muito importante mesmo !!!!!!!!!!"
        }
      ]

      {:ok, record} = MessageReader.import(file_name)

      assert %{
               "John Doe" => john_messages,
               "Ramon" => ramon_messages
             } == Agent.get(record, fn messages -> messages end)
    end
  end
end
