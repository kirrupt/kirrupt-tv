# Kirrupt TV

## Development

### Requirements

* local k8s cluster (e.g. minikube)
* skaffold

### Getting started
Start minikube:
```bash
minikube --memory 4095 --cpus 2 start
```

Start HTTP tunnel to k8s load balancers (will be created with `skaffold`):
```bash
minikube tunnel
```

Clone repository and run:
```bash
skaffold dev
```
to build images and start them in development mode on k8s.

Get IP of load balancer:
```bash
kubectl get services | grep 'ambassador' | grep 'LoadBalancer' | awk '{print $4}'
```

After application is started, you can visit [`<ip>:8080`](http://<ip>:8080) from your browser.

### Helpful commands
#### Import of existing database
```bash
kubectl exec -i $(kubectl get pods | grep "mariadb-" | awk '{print $1}') -- mysql -u root -ptest kirrupt < database.sql
```

#### Database migration
```bash
docker-compose exec app mix ecto.migrate
```

#### Ambassador Dashboard
Open [`http://localhost/ambassador/v0/diag/?loglevel=debug`](http://localhost/ambassador/v0/diag/?loglevel=debug) in your web browser.

# API docs

Api prefix: /api/v2
Headers:
  * Authorization: Token f5fe4750-5a95-4044-9639-a243b6c5d733

### POST /login

Request:

```json
  {
    "username": "user",
    "password": "pass"
  }
```

Response:

```json
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
```

### GET /user/info

Response:

```json
  {
    "username": "denc",
    "last_name": "T",
    "id": 7,
    "first_name": "D",
    "email": "d.t@gmail.com",
    "date_joined": "2012-05-10T13:32:40Z"
  }
```

### GET/POST /shows

Request:

```json
  both params are optional
  if Auth token is present and no param is given then will return all your shows

  {
    "show_ids": [1, 2, 3],
    "except_show_ids":[159, 74, 77, 170]
  }
```

Response:

```json
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
```

### POST /shows/updated-dates

Request:

```json
  {
    "show_ids": [159, 74, 77, 170],
  }
```

Response:

```json
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
```


### POST /shows/sync-ignored

Request:

```json
  {
    "shows": [
      {
        "show_id": 71,
        "ignored": false,
        "updated_at": "2017-02-17T11:30:02Z"
      },
      {
        "show_id": 10495,
        "ignored": false,
        "updated_at": "2017-02-17T13:29:02Z"
      }
    ]
  }
```

Response:

```json
  [
    {
      "updated_at": "2017-02-17T12:42:12Z",
      "show_id": 71,
      "ignored": true
    },
    {
      "updated_at": "2014-07-03T22:33:36Z",
      "show_id": 74,
      "ignored": false
    },
    {
      "updated_at": "2014-01-07T14:20:41Z",
      "show_id": 10495,
      "ignored": false
    }
  ]
```

### POST /shows/episodes

Request:

```json
  {
    "show_ids": [159, 74, 77, 170],
  }
```

Response:


```json
  [
    {
      "updated_at": "2015-10-18T21:12:15Z",
      "tvrage_url": "http://www.tvmaze.com/episodes/12192/breaking-bad-1x01-pilot",
      "title": "Pilot",
      "show_id": 74,
      "season": 1,
      "screencap": "shows/RL8I3FU43J.jpg",
      "id": 4369,
      "episode": 1,
      "airdate": "2008-01-20T00:00:00Z",
      "added": "2012-04-21T17:14:14Z"
    }
  ]
```

### POST /shows/episodes

Request:

```json
  {
    "show_ids": [159, 74, 77, 170],
  }
```

Response:

```json
  [
    {
      "updated_at": "2015-10-18T21:12:15Z",
      "tvrage_url": "http://www.tvmaze.com/episodes/12192/breaking-bad-1x01-pilot",
      "title": "Pilot",
      "show_id": 74,
      "season": 1,
      "id": 4369,
      "episode": 1,
      "airdate": "2008-01-20T00:00:00Z"
    }
  ]
```

### POST /shows/episodes/full

Request:

```json
  {
    "show_ids": [159, 74, 77, 170],
  }
```

Response:

```json
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
```

### POST /search/kirrupt

Request:

```json
  {
    "name": "Bones"
  }
```

Response:

```json
  [
    {
      "tvrage_url": "http://www.tvrage.com/shows/id-29816",
      "summary": "\"Bag of Bones\" is a ghost story of grief and lost love's enduring bonds, about an innocent child caught in a terrible crossfire and a new love haunted by past secrets.",
      "status": "Ended",
      "started": "2011-12-11",
      "picture_url": "https://kirrupt.com/tv/static/shows/5XRQ2IM7OS.jpg",
      "name": "Bag of Bones",
      "id": 9869,
      "genres":[
        "Drama",
        "Horror/Supernatural"
      ],
      "fixed_background": null,
      "ended": "2011-12-12"
    }
  ]
```

### POST /search/external

Request:

```json
  {
    "name": "Bones"
  }
```

Response:

```json
  [
    {
      "tvrage_url": "http://www.tvmaze.com/shows/13413/good-bones",
      "summary": "Mother and daughter duo Karen Jensen and Mina Starsiak are setting out to revitalize their hometown of Indianapolis one property at a time. They're buying up run down homes and transforming them into stunning urban remodels. With Mina's real estate know-how and Karen's no-nonsense legal background, these ladies are unstoppable in getting a property they want and enlisting their family's help with demo and construction. When it comes to exciting new homes in the city of Indianapolis, it all comes down to the ladies of Good Bones.",
      "status": "Running",
      "started": "2016-03-22",
      "picture_url": "http://tvmazecdn.com/uploads/images/original_untouched/48/120542.jpg",
      "name": "Good Bones",
      "genres":[],
      "external_id": 13413,
      "ended": null
    },
  ]
```

### GET /add/show/:id

Response:

```json
  {
    "success": true
  }
```

or HTTP 400 and

```json
  {
    "error": "COULD_NOT_ADD_SHOW"
  }
```

### GET /add/show/:external_id/external

Response:

```json
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
```

or HTTP 400 and

```json
  {
    "error": "COULD_NOT_ADD_EXTERNAL_SHOW"
  }
```
