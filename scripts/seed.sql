-- MySQL dump 10.16  Distrib 10.2.22-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: kirrupt
-- ------------------------------------------------------
-- Server version	10.2.22-MariaDB-1:10.2.22+maria~bionic

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `api_sessions`
--

DROP TABLE IF EXISTS `api_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_sessions` (
  `session_id` varchar(255) NOT NULL,
  `user_id` bigint(255) NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `episodes`
--

DROP TABLE IF EXISTS `episodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `episodes` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `show_id` bigint(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `season` int(255) NOT NULL,
  `episode` int(255) NOT NULL,
  `tvrage_url` varchar(255) NOT NULL,
  `airdate` datetime DEFAULT NULL,
  `added` datetime NOT NULL,
  `summary` text DEFAULT NULL,
  `screencap` varchar(255) DEFAULT NULL,
  `last_updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `show_id` (`show_id`,`season`,`episode`),
  KEY `airdate` (`airdate`),
  KEY `show_id_2` (`show_id`),
  KEY `season` (`season`),
  KEY `episode` (`episode`)
) ENGINE=InnoDB AUTO_INCREMENT=1393736 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feedback_messages`
--

DROP TABLE IF EXISTS `feedback_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feedback_messages` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `message` text NOT NULL,
  `added` datetime NOT NULL,
  `service` varchar(255) DEFAULT NULL,
  `status` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=986 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genres` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recommendation_item_similarity`
--

DROP TABLE IF EXISTS `recommendation_item_similarity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recommendation_item_similarity` (
  `mid1` int(11) NOT NULL,
  `mid2` int(11) NOT NULL,
  `similarity` double NOT NULL,
  `weight` int(255) NOT NULL DEFAULT 0,
  PRIMARY KEY (`mid1`,`mid2`),
  KEY `mid1` (`mid1`),
  KEY `mid2` (`mid2`),
  KEY `weight` (`weight`),
  KEY `similarity` (`similarity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recommendation_movie`
--

DROP TABLE IF EXISTS `recommendation_movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recommendation_movie` (
  `mid` int(11) NOT NULL,
  `release_date` year(4) NOT NULL,
  `title` varchar(255) NOT NULL,
  `avgrating` decimal(19,4) DEFAULT 0.0000
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recommendation_top_users`
--

DROP TABLE IF EXISTS `recommendation_top_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recommendation_top_users` (
  `uid` int(11) NOT NULL,
  `movie_count` int(11) NOT NULL,
  `avgrating` decimal(19,4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recommendation_top_users_ratings`
--

DROP TABLE IF EXISTS `recommendation_top_users_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recommendation_top_users_ratings` (
  `uid` int(11) NOT NULL,
  `mid` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `rating_date` date NOT NULL,
  KEY `uid` (`uid`),
  KEY `mid` (`mid`),
  KEY `rating` (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` bigint(20) NOT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `data` text DEFAULT NULL,
  `ip` varchar(255) NOT NULL,
  `last_activity` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shows`
--

DROP TABLE IF EXISTS `shows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shows` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `tvrage_url` varchar(255) DEFAULT NULL,
  `runtime` int(255) DEFAULT NULL,
  `genre` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `added` datetime NOT NULL,
  `last_checked` datetime NOT NULL,
  `wikipedia_url` varchar(255) DEFAULT NULL,
  `picture_url` varchar(255) DEFAULT NULL,
  `thumbnail_url` varchar(255) DEFAULT NULL,
  `wikipedia_checked` tinyint(1) NOT NULL,
  `tvrage_id` int(255) DEFAULT NULL,
  `year` int(255) DEFAULT NULL,
  `started` date DEFAULT NULL,
  `ended` date DEFAULT NULL,
  `origin_country` varchar(50) DEFAULT NULL,
  `airtime` varchar(50) DEFAULT NULL,
  `airday` varchar(50) DEFAULT NULL,
  `timezone` varchar(50) DEFAULT NULL,
  `summary` text DEFAULT NULL,
  `thetvdb_id` varchar(255) DEFAULT NULL,
  `fixed_thumb` varchar(255) DEFAULT NULL,
  `fixed_background` varchar(255) DEFAULT NULL,
  `fixed_banner` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `last_updated` datetime NOT NULL,
  `tvmaze_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name_2` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=20757 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shows_genres`
--

DROP TABLE IF EXISTS `shows_genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shows_genres` (
  `show_id` bigint(255) NOT NULL,
  `genre_id` int(255) NOT NULL,
  UNIQUE KEY `show_id` (`show_id`,`genre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 0,
  `last_login` datetime NOT NULL,
  `date_joined` datetime NOT NULL,
  `auto_hash` varchar(255) DEFAULT NULL,
  `registration_code` varchar(255) DEFAULT NULL,
  `password_code` varchar(255) DEFAULT NULL,
  `is_editor` tinyint(1) NOT NULL,
  `skype_handle` varchar(255) DEFAULT NULL,
  `is_developer` tinyint(1) DEFAULT 0,
  `is_admin` tinyint(1) DEFAULT 0,
  `google_id` varchar(255) DEFAULT NULL,
  `google_session_id` varchar(255) DEFAULT NULL,
  `password_new_hash` varchar(255) DEFAULT NULL,
  `is_premium` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email_index` (`email`),
  KEY `auto_hash` (`auto_hash`)
) ENGINE=InnoDB AUTO_INCREMENT=231222 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_dev_apps`
--

DROP TABLE IF EXISTS `users_dev_apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_dev_apps` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `api_key` varchar(255) NOT NULL,
  `secret_key` varchar(255) NOT NULL,
  `added` datetime NOT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_device_visit`
--

DROP TABLE IF EXISTS `users_device_visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_device_visit` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(255) NOT NULL,
  `device_id` bigint(255) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_device` (`user_id`,`device_id`)
) ENGINE=InnoDB AUTO_INCREMENT=575139 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_devices`
--

DROP TABLE IF EXISTS `users_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_devices` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(255) NOT NULL,
  `device_type` varchar(255) NOT NULL,
  `device_code` varchar(255) NOT NULL,
  `first_login` datetime NOT NULL,
  `last_login` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=226811 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_shows`
--

DROP TABLE IF EXISTS `users_shows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_shows` (
  `user_id` bigint(255) NOT NULL,
  `show_id` bigint(255) NOT NULL,
  `ignored` tinyint(1) DEFAULT 0,
  `modified` datetime NOT NULL,
  `date_added` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`,`show_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_shows_history_add_remove`
--

DROP TABLE IF EXISTS `users_shows_history_add_remove`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_shows_history_add_remove` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(255) NOT NULL,
  `show_id` bigint(255) NOT NULL,
  `action` tinyint(1) DEFAULT 0,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3000 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_shows_history_ignore`
--

DROP TABLE IF EXISTS `users_shows_history_ignore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_shows_history_ignore` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(255) NOT NULL,
  `show_id` bigint(255) NOT NULL,
  `ignored` tinyint(1) DEFAULT 0,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `watched_episodes`
--

DROP TABLE IF EXISTS `watched_episodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `watched_episodes` (
  `user_id` bigint(255) NOT NULL,
  `episode_id` bigint(255) NOT NULL,
  `added` datetime NOT NULL,
  PRIMARY KEY (`user_id`,`episode_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `watched_episodes_history`
--

DROP TABLE IF EXISTS `watched_episodes_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `watched_episodes_history` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(255) NOT NULL,
  `episode_id` bigint(255) NOT NULL,
  `date` datetime NOT NULL,
  `action` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33431 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `watched_episodes_status`
--

DROP TABLE IF EXISTS `watched_episodes_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `watched_episodes_status` (
  `user_id` bigint(255) NOT NULL,
  `episode_id` bigint(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`user_id`,`episode_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-03-25 21:33:54


--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schema_migrations` (
  `version` bigint(20) NOT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES (20161005083743,'2021-03-19 14:04:10'),(20161005131514,'2021-03-19 14:04:10'),(20161006131912,'2021-03-19 14:04:10'),(20161007084841,'2021-03-19 14:04:10'),(20161010111921,'2021-03-19 14:04:11'),(20161010114517,'2021-03-19 14:04:11'),(20161011112714,'2021-03-19 14:04:11'),(20161017132631,'2021-03-19 14:04:11'),(20161017133010,'2021-03-19 14:04:11'),(20161020072004,'2021-03-19 14:04:11'),(20161020073348,'2021-03-19 14:04:11'),(20161020073844,'2021-03-19 14:04:11'),(20161104142458,'2021-03-19 14:04:11'),(20161104143145,'2021-03-19 14:04:11'),(20161106112017,'2021-03-19 14:04:11');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;
