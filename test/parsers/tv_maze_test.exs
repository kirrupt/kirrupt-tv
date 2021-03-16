defmodule KirruptTv.TVMazeTest do
  use KirruptTv.ModelCase
  alias KirruptTv.Parser.TVMaze

  test "parse no year provided" do
    assert TVMaze.parse_year(%{:a => "b"}, []) == %{:a => "b"}
  end

  test "parse valid year provided" do
    assert TVMaze.parse_year(%{:a => "b"}, %{"premiered" => "2020-12-01"}) == %{
             :a => "b",
             :year => 2020
           }
  end

  test "parse invalid year provided" do
    assert TVMaze.parse_year(%{:a => "b"}, %{"premiered" => "2not-a-year020"}) == %{:a => "b"}
  end

  test "parse image provided" do
    assert TVMaze.parse_image(%{:a => "b"}, %{"image" => %{"original" => "path.jpg"}}) == %{
             :a => "b",
             :image => "path.jpg"
           }
  end

  test "parse no image provided" do
    assert TVMaze.parse_image(%{:a => "b"}, %{"image" => %{}}) == %{:a => "b"}
  end

  test "parse network provided" do
    n =
      TVMaze.parse_network(%{:a => "b"}, %{
        "network" => %{"country" => %{"code" => "US", "timezone" => "Los Angeles"}}
      })

    assert n == %{:a => "b", :origin_country => "US", :timezone => "Los Angeles"}
  end

  test "parse network without code" do
    n =
      TVMaze.parse_network(%{:a => "b"}, %{
        "network" => %{"country" => %{"timezone" => "Los Angeles"}}
      })

    assert n == %{:a => "b", :timezone => "Los Angeles"}
  end

  test "parse network without timezone" do
    n = TVMaze.parse_network(%{:a => "b"}, %{"network" => %{"country" => %{"code" => "US"}}})
    assert n == %{:a => "b", :origin_country => "US"}
  end

  test "parse no network provided" do
    assert TVMaze.parse_network(%{:a => "b"}, []) == %{:a => "b"}
  end

  test "parse schedule provided" do
    s =
      TVMaze.parse_schedule(%{:a => "b"}, %{
        "schedule" => %{"time" => "10:00", "days" => ["Tuesday", "Monday"]}
      })

    assert s == %{:a => "b", :airtime => "10:00", :airday => "Tuesday"}
  end

  test "parse no schedule provided" do
    assert TVMaze.parse_schedule(%{:a => "b"}, []) == %{:a => "b"}
  end

  test "parse premiered provided" do
    s = TVMaze.parse_premiered(%{:a => "b"}, %{"premiered" => "2020-01-01"})
    assert s == %{:a => "b", :started => "2020-01-01"}
  end

  test "parse no premiered provided" do
    assert TVMaze.parse_premiered(%{:a => "b"}, []) == %{:a => "b"}
  end

  test "parse genres provided" do
    s = TVMaze.parse_genres(%{:a => "b"}, %{"genres" => "value"})
    assert s == %{:a => "b", :genres => "value"}
  end

  test "parse no genres provided" do
    assert TVMaze.parse_genres(%{:a => "b"}, []) == %{:a => "b"}
  end

  test "parse episode image provided" do
    s = TVMaze.parse_episode_image(%{:a => "b"}, %{"image" => %{"original" => "value"}})
    assert s == %{:a => "b", :screencap => "value"}
  end

  test "parse no episode image provided" do
    assert TVMaze.parse_episode_image(%{:a => "b"}, []) == %{:a => "b"}
  end

  def get_episode(fields) do
    Map.merge(
      %{
        "number" => 2,
        "season" => 3,
        "airdate" => "airdate",
        "url" => "some-url",
        "name" => "Best EP ever",
        "summary" => "Some description",
        "image" => %{
          "original" => "cap.jpg"
        }
      },
      fields
    )
  end

  test "parse episode" do
    assert TVMaze.parse_episode(get_episode(%{})) == %{
             episode: 2,
             season: 3,
             airdate: "airdate",
             url: "some-url",
             title: "Best EP ever",
             summary: "Some description",
             screencap: "cap.jpg"
           }
  end

  test "parse embedded" do
    data = %{
      "_embedded" => %{
        "episodes" => [
          get_episode(%{}),
          get_episode(%{"number" => 4, "season" => 5})
        ]
      }
    }

    assert TVMaze.parse_embedded(%{:a => "b"}, data) == %{
             :a => "b",
             :episodes => [
               %{
                 airdate: "airdate",
                 episode: 2,
                 screencap: "cap.jpg",
                 season: 3,
                 summary: "Some description",
                 title: "Best EP ever",
                 url: "some-url"
               },
               %{
                 airdate: "airdate",
                 episode: 4,
                 screencap: "cap.jpg",
                 season: 5,
                 summary: "Some description",
                 title: "Best EP ever",
                 url: "some-url"
               }
             ]
           }
  end

  test "parse show data" do
    {_, contents} = File.read(Path.expand("../fixtures/tvmaze_show.json", __DIR__))
    data = TVMaze.process_response_body(contents)
    show = TVMaze.parse_show_data(data)

    assert show == %{
             airday: "Wednesday",
             airtime: "21:00",
             episodes: [
               %{
                 airdate: "2006-07-07",
                 episode: 1,
                 screencap:
                   "http://static.tvmaze.com/uploads/images/original_untouched/128/321823.jpg",
                 season: 1,
                 summary:
                   "Shawn Spencer is always moving on to the next fun thing and has never held a job for more than six months. He also has an incredible eye for detail and a near photographic memory, a skill drilled into him since he was young by his overbearing cop father. It's this ability that enables him to solve crimes just by watching the stories on the news. But as he goes in to pick up his reward check for one such helpful tip, he's hauled into questioning by Detective Lassiter for being in on the crime. No one could have that kind of information and not be on the inside. Backed into a corner, accused of being a partner in the crime, Shawn talks his way out of incarceration by claiming he got the information psychically. Since there's no way to disprove his claim, the police have to let him go.",
                 title: "Pilot",
                 url: "http://www.tvmaze.com/episodes/46536/psych-1x01-pilot"
               },
               %{
                 airdate: "2006-07-14",
                 episode: 2,
                 screencap:
                   "http://static.tvmaze.com/uploads/images/original_untouched/128/321824.jpg",
                 season: 1,
                 summary:
                   "Gus is a closet fan of spelling bees. He knows everything there is to know, from the major players to the winning words each year. When Shawn catches him watching the Regional Spelling Bee that he Tivo'd earlier, they see that this year's favorite, Brendan Vu, collapsed while spelling a word. Shawn doesn't think it was an accident. He notices something is wrong with Brendan's inhaler. They get a call from Interim Chief Vick to come down and investigate. This is Gus' dream come true.",
                 title: "Spellingg Bee",
                 url: "http://www.tvmaze.com/episodes/46537/psych-1x02-spellingg-bee"
               },
               %{
                 airdate: "2014-03-26",
                 episode: 10,
                 screencap:
                   "http://static.tvmaze.com/uploads/images/original_untouched/145/363950.jpg",
                 season: 8,
                 summary:
                   "Shawn and Gus assist Lassiter and Betsy Brannigan, with the help of Henry and Woody, in solving the murder of real estate executive, Warren Dern. Meanwhile, Shawn has decided to move to San Francisco to be with Juliet, but is struggling to find a way to break the news to Gus.",
                 title: "The Break Up",
                 url: "http://www.tvmaze.com/episodes/46656/psych-8x10-the-break-up"
               }
             ],
             genres: ["Drama", "Comedy", "Crime"],
             image: "http://static.tvmaze.com/uploads/images/original_untouched/4/11255.jpg",
             name: "Psych",
             origin_country: "US",
             runtime: 42,
             started: "2006-07-07",
             status: "Ended",
             summary:
               "Psych is a quick-witted comedy starring James Roday as young police consultant Shawn Spencer, who solves crimes with powers of observation so acute that Santa Barbara PD detectives think he's psychic. Psych also stars Dule Hill as Shawn's best friend and reluctant sidekick, Gus, and Corbin Bernsen as Shawn's disapproving father, Henry, who ironically was the one who honed his son's \"observation\" skills as a child.",
             timezone: "America/New_York",
             tvmaze_id: 517,
             url: "http://www.tvmaze.com/shows/517/psych",
             year: 2006
           }
  end
end
