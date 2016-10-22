CREATE TABLE `schema_migrations` (
  `version` bigint(20) NOT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `kirrupt`.`schema_migrations` (`version`, `inserted_at`) VALUES ('20161005083743', '2016-10-19 13:49:14');
INSERT INTO `kirrupt`.`schema_migrations` (`version`, `inserted_at`) VALUES ('20161005131514', '2016-10-20 06:35:56');
INSERT INTO `kirrupt`.`schema_migrations` (`version`, `inserted_at`) VALUES ('20161006131912', '2016-10-20 06:40:05');
INSERT INTO `kirrupt`.`schema_migrations` (`version`, `inserted_at`) VALUES ('20161007084841', '2016-10-20 06:47:07');
INSERT INTO `kirrupt`.`schema_migrations` (`version`, `inserted_at`) VALUES ('20161010111921', '2016-10-20 06:58:06');
INSERT INTO `kirrupt`.`schema_migrations` (`version`, `inserted_at`) VALUES ('20161010114517', '2016-10-20 07:03:16');
INSERT INTO `kirrupt`.`schema_migrations` (`version`, `inserted_at`) VALUES ('20161011112714', '2016-10-20 07:13:00');
INSERT INTO `kirrupt`.`schema_migrations` (`version`, `inserted_at`) VALUES ('20161017132631', '2016-10-20 07:16:21');
INSERT INTO `kirrupt`.`schema_migrations` (`version`, `inserted_at`) VALUES ('20161017133010', '2016-10-20 07:18:02');
INSERT INTO `kirrupt`.`schema_migrations` (`version`, `inserted_at`) VALUES ('20161020072004', '2016-10-20 07:24:57');
