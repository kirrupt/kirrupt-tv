# KirruptTv

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

# API docs

Api prefix: /api/v2
Headers:
  * Authorization: Token f5fe4750-5a95-4044-9639-a243b6c5d733

### POST /login

Request:

  {
    "username": "user",
    "password": "pass"
  }

Response:

  {
    "token": "f5fe4750-5a95-4044-9639-a243b6c5d733"
  }

  or HTTP 400

  {
    "error": "INVALID_USERNAME_OR_PASSWORD"
  }

  errors:
    - MISSING_USERNAME_OR_PASSWORD
    - INVALID_USERNAME_OR_PASSWORD


### GET /user/info

Response:

  {
    "username": "denc",
    "last_name": "T",
    "id": 7,
    "first_name": "D",
    "email": "d.t@gmail.com",
    "date_joined": "2012-05-10T13:32:40Z"
  }

### GET/POST /shows

Request:

  both params are optional
  if Auth token is present and no param is given then will return all your shows

  {
    "show_ids": [1, 2, 3],
    "except_show_ids":[159, 74, 77, 170]
  }

Response:

  [
    {
      "year": 2004,
      "updated_at": "2015-10-18T20:23:00Z",
      "tvrage_url": "http://www.tvrage.com/Entourage",
      "thumbnail_url": null,
      "summary": "The hit comedy series that takes a look at the day-to-day life of Vincent (Vince) Chase, a hot young actor in Hollywood, and his inner circle. He's brought with him from their hometown in Queens, NY: manager Eric, half-brother Drama, and friend Turtle. The series draws on the experiences of industry insiders to illustrate both the heady excesses of today's celebrity lifestyle, as well as the highs and lows of love and success in show biz. Eric, along with super-agent Ari, keep Vince's star rising while making sound decisions for a long-lasting career in a world of fleeting fame.",
      "status": "Ended",
      "started": "2004-07-18",
      "runtime": 30,
      "picture_url": "shows/OYESOSQR16.jpg",
      "name": "Entourage",
      "ignored": false,
      "id": 163,
      "genres":[
        "Drama",
        "Comedy"
      ],
      "fixed_thumb": "shows/94W38PEWJH.jpg",
      "fixed_banner": "shows/RIHJ68HJOT.jpg",
      "fixed_background": "shows/2X9Y6WD41J.jpg",
      "ended": "2011-09-11",
      "airtime": "22:30",
      "airday": "Sunday",
      "added": "2012-04-21T17:15:10Z"
    }
  ]

### POST /shows/updated-dates

Request:

  {
    "show_ids": [159, 74, 77, 170],
  }

Response:

  [
    {
      "updated_at": "2016-09-08T23:05:02Z",
      "id": 74,
      "episodes": [
        {
          "updated_at": "2015-10-18T21:12:15Z",
          "id": 4369
        }
      ]
    }
  ]

### POST /shows/episodes

Request:

  {
    "show_ids": [159, 74, 77, 170],
  }

Response:

  [
    {
      "updated_at": "2015-10-18T21:12:15Z",
      "tvrage_url": "http://www.tvmaze.com/episodes/12192/breaking-bad-1x01-pilot",
      "title": "Pilot",
      "show": 74,
      "season": 1,
      "screencap": "shows/RL8I3FU43J.jpg",
      "id": 4369,
      "episode": 1,
      "airdate": "2008-01-20T00:00:00Z",
      "added": "2012-04-21T17:14:14Z"
    }
  ]

### POST /shows/episodes

Request:

  {
    "show_ids": [159, 74, 77, 170],
  }

Response:

  [
    {
      "updated_at": "2015-10-18T21:12:15Z",
      "tvrage_url": "http://www.tvmaze.com/episodes/12192/breaking-bad-1x01-pilot",
      "title": "Pilot",
      "show": 74,
      "season": 1,
      "id": 4369,
      "episode": 1,
      "airdate": "2008-01-20T00:00:00Z"
    }
  ]

### POST /shows/episodes/full

Request:

  {
    "show_ids": [159, 74, 77, 170],
  }

Response:

  [
    {
      "updated_at": "2015-10-18T21:12:15Z",
      "tvrage_url": "http://www.tvmaze.com/episodes/12192/breaking-bad-1x01-pilot",
      "title": "Pilot",
      "summary": "A high-school chemistry teacher (Bryan Cranston) is diagnosed with a deadly cancer, so he puts his expertise to use and teams with an ex-student (Aaron Paul) to manufacture top-grade crystal meth in hopes of providing for his family after he's gone.",
      "show": 74,
      "season": 1,
      "screencap": "shows/RL8I3FU43J.jpg",
      "id": 4369,
      "episode": 1,
      "airdate": "2008-01-20T00:00:00Z"
    }
  ]
