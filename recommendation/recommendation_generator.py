#!/usr/bin/python

import MySQLdb
import json

class user_show_rating(object):
    user_id = -1
    show_id = -1
    user_count = 0
    show_count = 0
    rating = 0

    def __init__(self, user_id, show_id, user_count, show_count, rating):
        self.user_id = user_id
        self.show_id = show_id
        self.user_count = user_count
        self.show_count = show_count
        self.rating = rating

def create_tables(db, cursor):
    sql = []

    sql.append("""
CREATE TABLE IF NOT EXISTS `recommendation_item_similarity` (
  `mid1` int(11) NOT NULL,
  `mid2` int(11) NOT NULL,
  `similarity` double NOT NULL,
  `weight` int(255) NOT NULL DEFAULT '0',
  PRIMARY KEY (`mid1`,`mid2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;""")


    sql.append("""CREATE TABLE IF NOT EXISTS `recommendation_movie` (
  `mid` int(11) NOT NULL,
  `release_date` year(4) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8 NOT NULL,
  `avgrating` decimal(19,4) DEFAULT '0.0000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;""")

    sql.append("""CREATE TABLE IF NOT EXISTS `recommendation_top_users` (
  `uid` int(11) NOT NULL,
  `movie_count` int(11) NOT NULL,
  `avgrating` decimal(19,4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;""")

    sql.append("""CREATE TABLE IF NOT EXISTS `recommendation_top_users_ratings` (
  `uid` int(11) NOT NULL,
  `mid` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `rating_date` date NOT NULL,
  KEY `uid` (`uid`),
  KEY `mid` (`mid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;""")
    
    for s in sql:
        cursor.execute(s)
        db.commit()



def run():
    config = json.loads(open("config.json", "r").read())

    # Open database connection
    db = MySQLdb.connect(config['host'],config['user'],config['password'],config['name'] )
    
    # prepare a cursor object using cursor() method
    cursor = db.cursor(MySQLdb.cursors.DictCursor)

    create_tables(db, cursor)
    
    calculate_user_ratings(db, cursor)
    calculate_movie_rating(db, cursor)
    calculate_top_users(db, cursor)

    cursor.execute("""TRUNCATE TABLE recommendation_item_similarity""")
    db.commit()
    
    # disconnect from server
    db.close()

def calculate_user_ratings(db, cursor):
    cursor.execute("""TRUNCATE TABLE recommendation_top_users_ratings""")
    db.commit()
    
    # execute SQL query using execute() method.
    cursor.execute('''select u.id as user_id, us.show_id as show_id, COUNT(*) as user_count, (SELECT COUNT( * )
                        FROM shows s
                        LEFT JOIN episodes e ON e.show_id = s.id WHERE s.id = us.show_id AND e.airdate <= CURDATE()
                        GROUP BY s.id) as show_count from users u join users_shows us on us.user_id = u.id join episodes e on e.show_id = us.show_id join watched_episodes we on we.episode_id = e.id and we.user_id = u.id group by user_id, show_id''')
    
    # Fetch a single row using fetchone() method.
    data = cursor.fetchall()
    us_rating = []
    
    for row in data:
        rating = int(float(row['user_count']) * 10 / float(row['show_count']))
    
        if rating > 10:
            rating = 10
    
        us_rating.append(user_show_rating(row['user_id'], row['show_id'], row['user_count'], row['show_count'], rating))
    
    for sh in us_rating:
        cursor.execute ('''INSERT INTO recommendation_top_users_ratings (uid, mid, rating, rating_date) VALUES ('%s','%s','%s', CURDATE()) ''', (sh.user_id, sh.show_id, sh.rating))
    
    db.commit()
def calculate_movie_rating(db, cursor):
    cursor.execute("""TRUNCATE TABLE recommendation_movie""")
    db.commit()
    
    # execute SQL query using execute() method.
    cursor.execute('''select id, year, name
                        from shows''')
    
    # Fetch a single row using fetchone() method.
    data = cursor.fetchall()
    for row in data:
        cursor.execute ('''INSERT INTO recommendation_movie (mid, release_date, title) VALUES (%s,%s,%s) ''', (row['id'], 2000, row['name']))
    
    db.commit()
    
    
    cursor.execute('''SELECT mid, avg(rating) as avg
                        FROM recommendation_top_users_ratings
                        group by mid''')
    
    data = cursor.fetchall()
    for row in data:
        cursor.execute ('''UPDATE recommendation_movie SET avgrating=%s WHERE mid=%s ''', (row['avg'], row['mid']))
    
    db.commit()

def calculate_top_users(db, cursor):
    cursor.execute("""TRUNCATE TABLE recommendation_top_users""")
    db.commit()
    
    # execute SQL query using execute() method.
    cursor.execute('''select uid, count(mid) as count, avg(rating) as avg
                    from recommendation_top_users_ratings
                    group by uid''')
    
    # Fetch a single row using fetchone() method.
    data = cursor.fetchall()
    for row in data:
        cursor.execute ('''INSERT INTO recommendation_top_users (uid, movie_count, avgrating) VALUES ('%s','%s','%s') ''', (row['uid'], row['count'], float(row['avg'])))
    
    db.commit()

if __name__ == '__main__':
    run()

