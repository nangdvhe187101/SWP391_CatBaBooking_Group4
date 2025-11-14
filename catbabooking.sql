-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: catbabooking
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `amenities`
--

DROP TABLE IF EXISTS `amenities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amenities` (
  `amenity_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`amenity_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amenities`
--

LOCK TABLES `amenities` WRITE;
/*!40000 ALTER TABLE `amenities` DISABLE KEYS */;
INSERT INTO `amenities` VALUES (2,'Bãi đỗ xe miễn phí'),(4,'Bữa sáng'),(6,'Hồ bơi ngoài trời'),(3,'Máy lạnh'),(1,'WiFi miễn phí'),(5,'Xe đưa đón sân bay');
/*!40000 ALTER TABLE `amenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `areas`
--

DROP TABLE IF EXISTS `areas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `areas` (
  `area_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`area_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `areas`
--

LOCK TABLES `areas` WRITE;
/*!40000 ALTER TABLE `areas` DISABLE KEYS */;
INSERT INTO `areas` VALUES (5,'Bến Bèo'),(4,'Làng Việt Hải'),(2,'Trung tâm Cát Bà'),(1,'TT.Cát Bà'),(3,'Vườn quốc gia Cát Bà');
/*!40000 ALTER TABLE `areas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booked_rooms`
--

DROP TABLE IF EXISTS `booked_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booked_rooms` (
  `booked_room_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `room_id` int NOT NULL,
  `price_at_booking` decimal(12,2) NOT NULL,
  PRIMARY KEY (`booked_room_id`),
  KEY `booking_id` (`booking_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `booked_rooms_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
  CONSTRAINT `booked_rooms_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booked_rooms`
--

LOCK TABLES `booked_rooms` WRITE;
/*!40000 ALTER TABLE `booked_rooms` DISABLE KEYS */;
INSERT INTO `booked_rooms` VALUES (1,51,1,850000.00);
/*!40000 ALTER TABLE `booked_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booked_tables`
--

DROP TABLE IF EXISTS `booked_tables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booked_tables` (
  `booked_table_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `table_id` int NOT NULL,
  PRIMARY KEY (`booked_table_id`),
  KEY `booking_id` (`booking_id`),
  KEY `table_id` (`table_id`),
  CONSTRAINT `booked_tables_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
  CONSTRAINT `booked_tables_ibfk_2` FOREIGN KEY (`table_id`) REFERENCES `restaurant_tables` (`table_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booked_tables`
--

LOCK TABLES `booked_tables` WRITE;
/*!40000 ALTER TABLE `booked_tables` DISABLE KEYS */;
INSERT INTO `booked_tables` VALUES (9,12,1),(10,13,1),(11,14,3),(12,15,1),(13,16,1),(14,17,1),(15,18,1),(16,19,1),(17,20,7),(18,21,1),(19,22,3),(20,23,3),(21,24,4),(22,25,1),(23,26,1),(24,27,1),(25,28,1),(26,29,1),(27,30,1),(28,31,1),(29,32,1),(30,33,1),(31,34,3),(32,35,1),(33,36,3),(34,37,1),(35,38,1),(36,39,1),(37,40,3),(38,41,1),(39,42,1),(40,43,3),(41,44,1),(42,45,3),(43,46,4),(44,47,11),(45,48,7),(46,49,1),(47,50,1),(48,52,1);
/*!40000 ALTER TABLE `booked_tables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_dishes`
--

DROP TABLE IF EXISTS `booking_dishes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_dishes` (
  `booking_dish_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `dish_id` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `price_at_booking` decimal(12,2) NOT NULL,
  `notes` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`booking_dish_id`),
  KEY `idx_bd_booking` (`booking_id`),
  KEY `idx_bd_dish` (`dish_id`),
  CONSTRAINT `fk_bd_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_bd_dish` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`dish_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_dishes`
--

LOCK TABLES `booking_dishes` WRITE;
/*!40000 ALTER TABLE `booking_dishes` DISABLE KEYS */;
INSERT INTO `booking_dishes` VALUES (11,12,3,1,10000.00,''),(12,13,3,1,10000.00,''),(13,14,3,1,10000.00,''),(14,15,3,1,10000.00,''),(15,16,3,1,10000.00,''),(16,17,3,1,10000.00,''),(17,18,3,1,10000.00,''),(18,19,3,1,10000.00,'nướng kĩ'),(19,20,3,1,10000.00,''),(20,21,3,1,10000.00,'Nướng Xém'),(21,22,3,1,10000.00,''),(22,23,3,1,10000.00,''),(23,24,3,1,10000.00,''),(24,25,3,2,10000.00,''),(25,26,3,1,10000.00,''),(26,26,4,1,285000.00,''),(27,27,3,1,10000.00,''),(28,28,13,1,385000.00,''),(29,29,3,1,10000.00,''),(30,30,3,1,10000.00,''),(31,31,3,1,10000.00,''),(32,32,3,2,10000.00,''),(33,33,3,1,10000.00,''),(34,34,3,1,10000.00,''),(35,35,2,1,249000.00,''),(36,36,13,1,385000.00,''),(37,37,6,1,249000.00,'ít chua'),(38,38,3,1,10000.00,''),(39,39,3,1,10000.00,''),(40,40,2,1,249000.00,''),(41,41,3,1,10000.00,''),(42,42,3,2,10000.00,''),(43,43,3,1,10000.00,''),(44,44,3,1,10000.00,''),(45,45,3,1,10000.00,''),(46,46,3,1,10000.00,''),(47,47,3,1,10000.00,''),(48,47,6,1,249000.00,''),(49,48,3,1,10000.00,''),(50,49,3,1,10000.00,''),(51,50,3,1,10000.00,''),(52,52,3,1,10000.00,'');
/*!40000 ALTER TABLE `booking_dishes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `booking_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int DEFAULT NULL,
  `business_id` int NOT NULL,
  `booker_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `booker_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `booker_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `num_guests` int NOT NULL,
  `total_price` decimal(12,2) NOT NULL,
  `paid_amount` decimal(12,2) DEFAULT '0.00',
  `payment_status` enum('unpaid','partially_paid','fully_paid','refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'unpaid',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `reservation_start_time` datetime DEFAULT NULL,
  `reservation_end_time` datetime DEFAULT NULL,
  `status` enum('pending','confirmed','cancelled_by_user','cancelled_by_owner','completed','no_show') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `reservation_time` time DEFAULT NULL COMMENT 'Giờ đặt bàn cho restaurant (HH:MM)',
  `reservation_date` date DEFAULT NULL COMMENT 'Ngày đặt bàn cho restaurant',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `booking_code` (`booking_code`),
  KEY `user_id` (`user_id`),
  KEY `idx_booking_business_dates` (`business_id`,`reservation_start_time`,`status`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (12,'BKD57DFCA22487',NULL,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0327724169',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','22:00:00','2025-11-07','2025-11-10 03:17:04','2025-11-06 23:06:35'),(13,'BK125DDD122790',NULL,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0327724169',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:00:00','2025-11-07','2025-11-10 03:17:04','2025-11-06 23:06:35'),(14,'BKE2E7157A1701',NULL,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0327724169',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:00:00','2025-11-07','2025-11-10 03:17:04','2025-11-06 23:06:35'),(15,'BKBF4BB8894921',2,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0327724169',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','22:00:00','2025-11-07','2025-11-10 03:17:04','2025-11-06 23:06:35'),(16,'BK5A27C9916840',NULL,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0327724169',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:13:00','2025-11-11','2025-11-10 03:17:04','2025-11-06 23:06:35'),(17,'BKFB53E45C9901',2,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0327724169',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:00:00','2025-11-15','2025-11-10 03:17:04','2025-11-06 23:06:35'),(18,'BKD6EA7F494583',2,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0327724169',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','18:00:00','2025-11-11','2025-11-10 03:17:04','2025-11-06 23:06:35'),(19,'BK7A9C02ED1445',2,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0327724169',4,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:00:00','2025-11-12','2025-11-10 03:17:04','2025-11-06 23:06:35'),(20,'BKC6BD88D29878',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0334403380',6,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:30:00','2025-11-12','2025-11-10 03:17:04','2025-11-06 23:06:35'),(21,'BKEED58C175946',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0334403380',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:00:00','2025-11-13','2025-11-10 03:17:04','2025-11-06 23:06:35'),(22,'BK92C94D0E1205',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0334403380',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:30:00','2025-11-13','2025-11-10 03:17:04','2025-11-06 23:06:35'),(23,'BKBA2851774981',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0334403380',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','19:00:00','2025-11-11','2025-11-10 03:17:04','2025-11-06 23:06:35'),(24,'BKC3AB57C66645',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0334403380',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','19:00:00','2025-11-13','2025-11-10 03:17:04','2025-11-06 23:06:35'),(25,'BKAF3C7E678304',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0334403380',2,20000.00,20000.00,'fully_paid','',NULL,NULL,'confirmed','20:30:00','2025-11-30','2025-11-06 23:14:09','2025-11-06 23:13:28'),(26,'BKB0257BDD0648',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0334403380',2,295000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:00:00','2025-11-20','2025-11-10 03:17:04','2025-11-06 23:40:40'),(27,'BK94857F858031',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0334403380',2,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','20:00:00','2025-11-21','2025-11-06 23:50:46','2025-11-06 23:50:28'),(28,'BK32D799874883',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0334403380',2,385000.00,385000.00,'fully_paid','',NULL,NULL,'confirmed','09:00:00','2025-11-22','2025-11-07 00:01:02','2025-11-07 00:00:44'),(29,'BKA706C8B38147',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0334403380',2,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','22:00:00','2025-11-21','2025-11-07 00:06:03','2025-11-07 00:05:28'),(30,'BKD0C04F3F5719',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0334403380',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','21:00:00','2025-11-16','2025-11-10 03:17:04','2025-11-07 00:08:35'),(31,'BKA6AEA0661321',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0327724169',2,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','20:00:00','2025-11-19','2025-11-07 03:06:54','2025-11-07 03:06:41'),(32,'BKD0D8B03B8407',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0327724169',3,20000.00,20000.00,'fully_paid','',NULL,NULL,'confirmed','20:00:00','2025-11-18','2025-11-07 04:01:11','2025-11-07 04:00:38'),(33,'BKD932BF444829',NULL,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0327724169',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:00:00','2025-11-09','2025-11-10 03:17:04','2025-11-09 16:48:04'),(34,'BK56925F808774',NULL,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0327724169',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','21:00:00','2025-11-09','2025-11-10 03:17:04','2025-11-09 16:49:28'),(35,'BK6B86D57D2584',NULL,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0327724169',2,249000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','08:30:00','2025-11-18','2025-11-10 03:17:04','2025-11-09 17:21:22'),(36,'BKA8F33A524298',NULL,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0327724169',2,385000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:30:00','2025-11-15','2025-11-10 03:17:04','2025-11-09 17:31:24'),(37,'BK5650F8035241',NULL,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0327724169',2,249000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','10:00:00','2025-11-10','2025-11-10 03:30:29','2025-11-10 03:25:05'),(38,'BK4330EE025754',NULL,4,'Nguyễn Văn Tiến','nangdz14@gmail.com','0327724169',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','13:00:00','2025-11-10','2025-11-10 03:54:29','2025-11-10 03:48:35'),(39,'BKCC2F65F86941',NULL,4,'Nguyễn Văn Đạt','nangdz14@gmail.com','0327752851',4,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','20:00:00','2025-11-10','2025-11-10 11:57:43','2025-11-10 11:57:06'),(40,'BKC49C72366157',8,4,'Phạm Vy','phamthituongvy30112004@gmail.com','0986868686',2,249000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','21:00:00','2025-11-10','2025-11-10 15:31:12','2025-11-10 15:26:06'),(41,'BKE0E0CF404229',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0986868686',2,10000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán',NULL,NULL,'cancelled_by_owner','20:30:00','2025-11-12','2025-11-10 18:32:12','2025-11-10 18:27:04'),(42,'BK97285A8B3381',2,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0986868686',2,20000.00,20000.00,'fully_paid','',NULL,NULL,'confirmed','12:30:00','2025-11-13','2025-11-13 14:14:49','2025-11-13 14:14:23'),(43,'BKAA67E4221278',2,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0986868686',2,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','11:30:00','2025-11-13','2025-11-13 14:30:36','2025-11-13 14:30:11'),(44,'BKEE5205708644',2,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0986868686',2,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','21:30:00','2025-11-13','2025-11-13 14:32:32','2025-11-13 14:32:18'),(45,'BK352DCBC83389',2,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0986868686',2,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','20:00:00','2025-11-13','2025-11-13 15:00:18','2025-11-13 14:59:53'),(46,'BK9F1ABC985437',2,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0986868686',2,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','20:30:00','2025-11-13','2025-11-13 15:21:07','2025-11-13 15:20:55'),(47,'BK0698E0F34645',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0327724169',2,259000.00,259000.00,'fully_paid','',NULL,NULL,'confirmed','21:30:00','2025-11-13','2025-11-13 15:27:13','2025-11-13 15:27:04'),(48,'BKA5A42A733091',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0327724169',2,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','21:30:00','2025-11-13','2025-11-13 15:29:44','2025-11-13 15:29:33'),(49,'BKC4D7BE455073',2,4,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0327724169',2,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','20:30:00','2025-11-20','2025-11-13 15:32:55','2025-11-13 15:32:35'),(50,'BK6C5166325273',2,4,'Dao Van Nang','nangdvhe187101@fpt.edu.vn','0327724169',2,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','21:30:00','2025-11-24','2025-11-13 15:39:12','2025-11-13 15:38:55'),(51,'HSC6D2425F2502',NULL,2,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','0327724169',2,1700000.00,0.00,'refunded','\n[AUTO] Quá 5 phút không thanh toán','2025-11-15 07:00:00','2025-11-17 05:00:00','cancelled_by_owner',NULL,NULL,'2025-11-14 01:33:11','2025-11-14 01:27:52'),(52,'BK12D52BD28069',19,4,'Nguyễn Nhật Minh','nangdz14@gmail.com','0327724169',2,10000.00,10000.00,'fully_paid','',NULL,NULL,'confirmed','20:00:00','2025-11-14','2025-11-14 03:41:00','2025-11-14 03:39:38');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_amenities`
--

DROP TABLE IF EXISTS `business_amenities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_amenities` (
  `business_id` int NOT NULL,
  `amenity_id` int NOT NULL,
  PRIMARY KEY (`business_id`,`amenity_id`),
  KEY `amenity_id` (`amenity_id`),
  CONSTRAINT `business_amenities_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  CONSTRAINT `business_amenities_ibfk_2` FOREIGN KEY (`amenity_id`) REFERENCES `amenities` (`amenity_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_amenities`
--

LOCK TABLES `business_amenities` WRITE;
/*!40000 ALTER TABLE `business_amenities` DISABLE KEYS */;
INSERT INTO `business_amenities` VALUES (2,1);
/*!40000 ALTER TABLE `business_amenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_cuisines`
--

DROP TABLE IF EXISTS `business_cuisines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_cuisines` (
  `business_id` int NOT NULL,
  `cuisine_id` int NOT NULL,
  PRIMARY KEY (`business_id`,`cuisine_id`),
  KEY `cuisine_id` (`cuisine_id`),
  CONSTRAINT `business_cuisines_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  CONSTRAINT `business_cuisines_ibfk_2` FOREIGN KEY (`cuisine_id`) REFERENCES `cuisine_types` (`cuisine_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_cuisines`
--

LOCK TABLES `business_cuisines` WRITE;
/*!40000 ALTER TABLE `business_cuisines` DISABLE KEYS */;
INSERT INTO `business_cuisines` VALUES (4,1),(4,2),(4,3);
/*!40000 ALTER TABLE `business_cuisines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_occasions`
--

DROP TABLE IF EXISTS `business_occasions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_occasions` (
  `business_id` int NOT NULL,
  `occasion_id` int NOT NULL,
  PRIMARY KEY (`business_id`,`occasion_id`),
  KEY `occasion_id` (`occasion_id`),
  CONSTRAINT `business_occasions_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  CONSTRAINT `business_occasions_ibfk_2` FOREIGN KEY (`occasion_id`) REFERENCES `occasions` (`occasion_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_occasions`
--

LOCK TABLES `business_occasions` WRITE;
/*!40000 ALTER TABLE `business_occasions` DISABLE KEYS */;
INSERT INTO `business_occasions` VALUES (2,1);
/*!40000 ALTER TABLE `business_occasions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_restaurant_types`
--

DROP TABLE IF EXISTS `business_restaurant_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_restaurant_types` (
  `business_id` int NOT NULL,
  `type_id` int NOT NULL,
  PRIMARY KEY (`business_id`,`type_id`),
  KEY `type_id` (`type_id`),
  CONSTRAINT `business_restaurant_types_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  CONSTRAINT `business_restaurant_types_ibfk_2` FOREIGN KEY (`type_id`) REFERENCES `restaurant_types` (`type_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_restaurant_types`
--

LOCK TABLES `business_restaurant_types` WRITE;
/*!40000 ALTER TABLE `business_restaurant_types` DISABLE KEYS */;
INSERT INTO `business_restaurant_types` VALUES (4,3),(4,4);
/*!40000 ALTER TABLE `business_restaurant_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `businesses`
--

DROP TABLE IF EXISTS `businesses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `businesses` (
  `business_id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('homestay','restaurant') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` int DEFAULT NULL,
  `avg_rating` decimal(3,2) DEFAULT '0.00',
  `review_count` int DEFAULT '0',
  `capacity` int DEFAULT NULL,
  `num_bedrooms` int DEFAULT NULL,
  `price_per_night` decimal(12,2) DEFAULT NULL,
  `status` enum('active','pending','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `opening_hour` time DEFAULT NULL,
  `closing_hour` time DEFAULT NULL,
  PRIMARY KEY (`business_id`),
  KEY `area_id` (`area_id`),
  KEY `idx_owner_id` (`owner_id`),
  CONSTRAINT `businesses_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `businesses_ibfk_2` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `businesses`
--

LOCK TABLES `businesses` WRITE;
/*!40000 ALTER TABLE `businesses` DISABLE KEYS */;
INSERT INTO `businesses` VALUES (2,6,'Cat Ba Eco Garden Homestay','homestay','Số 5 Núi Ngọc, Thị trấn Cát Bà, Hải Phòng','Homestay thân thiện với môi trường, có vườn xanh, bếp chung, gần biển.','https://cf.bstatic.com/xdata/images/hotel/max1024x768/624962683.jpg?k=70302be5175e9ecc65e4632c4b1ccb1fceb7c64c69e79b745effb9673960142d&o=&hp=1',1,0.00,0,10,5,1500000.00,'active','2025-10-13 16:10:13','2025-10-14 05:13:21',NULL,NULL),(3,7,'aaaaa','homestay','1111 aaa','ddep',NULL,NULL,0.00,0,NULL,NULL,NULL,'active','2025-10-14 06:02:54','2025-10-14 06:03:44',NULL,NULL),(4,8,'Secret Garden Restaurant','restaurant','169 Núi Ngọc, TT. Cát Bà, Cát Hải, Hải Phòng 180000, Vietnam','Giữa Cát Bà nhộn nhịp, tôi đã tâm huyết tạo ra Secret Garden như một \"khu vườn bí mật\" đúng nghĩa – một không gian xanh mát, yên bình, nơi quý khách có thể thực sự thư giãn và tạm lánh xa ồn ào. Chúng tôi chuyên tâm phục vụ những hương vị tinh túy của ẩm thực Việt Nam và đặc biệt là nguồn hải sản tươi ngon nhất mà biển Cát Bà ban tặng. Mỗi món ăn đều chứa đựng sự chăm chút của đội ngũ chúng tôi.','https://media-cdn.tripadvisor.com/media/photo-s/1a/55/6e/f9/the-entrance-of-secret.jpg',5,5.00,0,100,NULL,NULL,'active','2025-10-21 12:58:53','2025-11-12 18:34:53','08:00:00','23:00:00'),(25,9,'Cat Ba Santorini Homestay','homestay','Số 12, ngõ 243 Cái Bèo','Lấy cảm hứng từ hòn đảo Santorini xinh đẹp của Hy Lạp, homestay này có tầm nhìn tuyệt đẹp ra biển, hồ bơi và quán cà phê trên sân thượng. Lý tưởng cho các cặp đôi và nhóm bạn.','https://sinhtour.vn/wp-content/uploads/2024/07/homestay-cat-ba-10.jpg',2,4.00,0,10,20,3000000.00,'active','2025-10-15 01:14:36','2025-10-25 06:47:54',NULL,NULL),(26,10,'Lan Homestay','homestay','Làng Việt Hải, Cát Hải, Hải Phòng','Nằm trong làng Việt Hải yên bình thuộc Vườn quốc gia Cát Bà, Lan Homestay mang đến một không gian thanh thản...','https://cf.bstatic.com/xdata/images/hotel/max1024x768/241502454.jpg?k=9dd6711aa689fa7440734297b9a7321d999dbfd03e60ecb4a14a0c35cace09f3&o=&hp=1',1,4.50,0,10,5,500000.00,'active','2025-10-15 01:19:10','2025-10-27 08:46:46',NULL,NULL),(27,11,'Little Cat Ba Homestay','homestay','350 Hà Sen, Thị trấn Cát Bà, Cát Hải, Hải Phòng','Một homestay ấm cúng và thân thiện...','https://pix10.agoda.net/hotelImages/1176637/0/5773c402c9081e63783368666a25369b.jpeg?ce=0&s=414x232',3,0.00,0,23,10,200000.00,'active','2025-10-15 01:21:32','2025-10-27 20:54:35',NULL,NULL),(28,12,'Cat Ba Rustic Homestay','homestay','Đường xuyên đảo, Vườn Quốc gia Cát Bà, Hải Phòng','Homestay mang phong cách mộc mạc...',NULL,NULL,0.00,0,NULL,NULL,NULL,'active','2025-10-15 01:23:35','2025-10-15 01:26:15',NULL,NULL),(29,13,'Green Homestay','homestay','Số 192, đường 1/4, Thị trấn Cát Bà, Cát Hải, Hải Phòng','Tọa lạc tại vị trí thuận tiện...',NULL,NULL,0.00,0,NULL,NULL,NULL,'active','2025-10-15 01:25:26','2025-10-15 01:26:21',NULL,NULL),(30,14,'Eco Floating Farm Stay Cai Beo - Standard Double Room','homestay','Đảo Khỉ, Cát Hải, Hải Phòng 01234, Vietnam','đẹp',NULL,NULL,0.00,0,NULL,NULL,NULL,'active','2025-10-29 19:36:56','2025-10-31 04:38:03',NULL,NULL),(31,17,'thaohomestay','homestay','Đảo Khỉ, Cát Hải, Hải Phòng 01234, Vietnam','đẹp',NULL,NULL,0.00,0,NULL,NULL,NULL,'rejected','2025-10-31 04:41:37','2025-10-31 04:42:06',NULL,NULL),(32,18,'The Three M Restaurant','homestay','The Three M Restaurant','Đẹp',NULL,NULL,0.00,0,NULL,NULL,NULL,'active','2025-10-31 04:44:08','2025-10-31 04:44:40',NULL,NULL),(33,20,'Celery Restaurant','restaurant','Celery Restaurant','Nhà hàng Celery (227 Núi Ngọc, Cát Bà) là một nhà hàng thuần chay nổi bật. Quán chuyên các món chay Việt Nam và quốc tế, được đánh giá cao vì đồ ăn ngon, giá hợp lý và không gian sạch sẽ. Đây là lựa chọn hàng đầu cho ẩm thực lành mạnh tại Cát Bà.',NULL,NULL,0.00,0,NULL,NULL,NULL,'active','2025-11-07 03:42:13','2025-11-12 22:34:42',NULL,NULL),(34,21,'Cat Ba Cay Da','restaurant','Cát Bà, Hải Phòng','Đẹp',NULL,NULL,0.00,0,NULL,NULL,NULL,'pending','2025-11-10 14:00:48','2025-11-10 14:00:48',NULL,NULL),(35,22,'Vua hải sản','restaurant','Cát Bà, Hải Phòng','ngon',NULL,NULL,0.00,0,NULL,NULL,NULL,'pending','2025-11-12 17:49:58','2025-11-12 17:49:58',NULL,NULL);
/*!40000 ALTER TABLE `businesses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuisine_types`
--

DROP TABLE IF EXISTS `cuisine_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuisine_types` (
  `cuisine_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`cuisine_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuisine_types`
--

LOCK TABLES `cuisine_types` WRITE;
/*!40000 ALTER TABLE `cuisine_types` DISABLE KEYS */;
INSERT INTO `cuisine_types` VALUES (3,'hải sản'),(1,'lẩu'),(2,'nướng');
/*!40000 ALTER TABLE `cuisine_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dish_categories`
--

DROP TABLE IF EXISTS `dish_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dish_categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `business_id` int NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_order` int DEFAULT '0',
  PRIMARY KEY (`category_id`),
  KEY `idx_category_business` (`business_id`),
  CONSTRAINT `fk_category_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dish_categories`
--

LOCK TABLES `dish_categories` WRITE;
/*!40000 ALTER TABLE `dish_categories` DISABLE KEYS */;
INSERT INTO `dish_categories` VALUES (1,4,'Nướng',0),(2,4,'Hải Sản',0),(3,4,'Lẩu',0);
/*!40000 ALTER TABLE `dish_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dishes`
--

DROP TABLE IF EXISTS `dishes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dishes` (
  `dish_id` int NOT NULL AUTO_INCREMENT,
  `business_id` int NOT NULL,
  `category_id` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` decimal(12,2) NOT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`dish_id`),
  KEY `idx_dish_business` (`business_id`),
  KEY `idx_dish_category` (`category_id`),
  CONSTRAINT `fk_dish_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_dish_category` FOREIGN KEY (`category_id`) REFERENCES `dish_categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dishes`
--

LOCK TABLES `dishes` WRITE;
/*!40000 ALTER TABLE `dishes` DISABLE KEYS */;
INSERT INTO `dishes` VALUES (1,4,1,'Sườn nướng mật ong','Sườn được chặt miếng vừa ăn, tẩm ướp gia vị theo công thức riêng của nhà hàng, sau đó nướng trực tiếp trên bếp than, khi nướng phết thêm mật ong để tạo hương vị đặc trưng. Sườn nướng vừa tới, chín mềm, róc thịt có màu cánh gián đậm nhìn thôi đã thấy ngon mắt.',185000.00,'/CatBaBooking/uploads/dishes/cd826ac9d7d04432992c2c354e790fa4.webp',1),(2,4,1,'Mực Khô Nướng','Mực khô lựa chọn toàn những con to, đẹp, nướng trực tiếp trên bếp than, sau đó đập dập, xé sợi là có thể thưởng thức cùng những cốc bia mát lạnh.',249000.00,'/CatBaBooking/uploads/dishes/c4f28c8268b446a4b114ac859e287969.webp',1),(3,4,1,'Lợn mán nướng','Lợn mán nướng giềng mẻ là món ăn đậm đà, đốt cháy mọi cảm xúc vị giác của bạn. Thịt lợn mán với vị ngọt tự nhiên, khi được ướp với riềng, mẻ, sả, và các loại gia vị khác, rồi nướng lên sẽ tạo nên hương vị thơm ngon, đậm đà, rất đưa mồi.',10000.00,'/CatBaBooking/uploads/dishes/770a8bdb0b7e4f7fa769fa11894c1597.webp',1),(4,4,2,'Mực Hấp Chanh','Mực hấp chanh là món ăn thú vị nên thử khi đến Cát Bà cùng bạn bè, người thân. Mực tươi được hấp với quả chanh tươi lát mỏng và rưới thêm nước sốt chua cay. Miếng mực giòn sần sật, ngọt tự nhiên lại ăn cùng nước chấm tỏi ớt, gừng, sả thì cực tốn bia.',285000.00,'/CatBaBooking/uploads/dishes/b083746a93c54386a150f94b648410ec.webp',1),(6,4,2,'Tôm tắm sốt thái','Tôm tắm sốt Thái có vị ngọt của tôm tươi sần sật, quyện cùng hương thơm đặc trưng dễ gây nghiện của sốt Thái chua cay khó cưỡng. Đầu tôm được chiên giòn ăn kèm với xoài xanh, cà rốt bào sợi cực kỳ hợp lý.',249000.00,'/CatBaBooking/uploads/dishes/61f779ecb04045ccafa218ce807b78e8.webp',1),(7,4,2,'Tôm chiên hoàng kim','Tôm tươi, căng mọng đem chiên vàng giòn rồi lại đảo qua gia vị đậm đà tạo nên món ăn hấp dẫn, ăn một miếng là không ngừng lại được.',249000.00,'/CatBaBooking/uploads/dishes/d91433265a8840b2ab87498a87c5e4c6.webp',1),(8,4,2,'Ốc hương ủ muối thảo mộc','Những con ốc hương tươi ngon được ủ cùng muối biển tinh khiết tạo nên hương vị đậm đà, thơm lừng. Khi thưởng thức, cảm giác giòn béo, dai ngon và đậm đà lan tỏa trong khoang miệng, làm say mê từng miếng.',269000.00,'/CatBaBooking/uploads/dishes/029d010f4c2d4232bc40539716e9b14a.webp',1),(9,4,2,'Cá dưa chua tứ xuyên','Cá quả được om nguyên con, thịt cá chắc nịch, không bã, miếng nào miếng nấy ngấm nước om đậm đà. Kèm theo là mấy miếng đậu phụ nướng vàng ươm, béo ngậy, cùng những miếng tiết heo mềm mịn, ngấm vị, cắn vào tan chảy trong miệng.',469000.00,'/CatBaBooking/uploads/dishes/32a58b370eb74b10a751147c5aa1bb0f.webp',1),(10,4,3,'Lẩu hải sản kiểu thái','Lẩu hải sản kiểu Thái với những nguyên liệu tươi roi rói: Tôm, Mực, Bạch tuộc, Ba chỉ bò, Viên thả lẩu cùng nồi nước dùng chua cay chuẩn Thái chắc chắn sẽ kích thích vị giác của mọi người.',599000.00,'/CatBaBooking/uploads/dishes/027d3f11e7e544cfa4c66594c3ef764e.webp',1),(11,4,3,'Lẩu gà đen nấm rừng Vân Nam','nước cốt lẩu ngọt thanh, thơm lừng mùi thảo mộc, được ninh từ đủ loại nấm rừng Vân Nam quý hiếm. Ăn kèm lẩu là nửa con gà đen săn chắc, đã được lọc xương sẵn, chỉ việc nhúng vào rồi chén thôi. Kèm theo là đa dạng các loại đồ thả lẩu tươi ngon khác nữa. Đặc biệt, còn có set nấm riêng với nhiều loại nấm quý như đông trùng hạ thảo, nấm ngọc châm nâu...',499000.00,'/CatBaBooking/uploads/dishes/e2bb685aff914964bfd13f7bc97c21df.webp',1),(12,4,3,'Lẩu riêu cua bắp bò','Nước dùng có vị chua dịu từ giấm bỗng, dậy mùi thơm của riêu cua cùng với đa dạng các loại đồ nhúng: Bắp bò, Ba chỉ bò, Sườn sụn, Giò tai, Chả cá',589000.00,'/CatBaBooking/uploads/dishes/d4d59fba22684cc6ac88d51f13260b0a.webp',1),(13,4,1,'Gà đen nướng mắc khén','Gà nửa con, hạt mắc khén rang thơm, quả ớt cay, lá chanh, muối,củ sả. Chuẩn gia vị chẩm chéo để chấm gà, thơm phức mùi mắc kén và tê tê đầu lưỡi.',385000.00,'/CatBaBooking/uploads/dishes/c065bc06b537419dbe4c33bbaa13114e.webp',1),(14,4,2,'Cá chép om dưa','Cá chép om dưa hấp dẫn với thịt cá tươi ngon kết hợp vị chua dịu của dưa muối, mẻ, cay nồng của sốt sa tế hòa quyện với nhau tạo nên sức hấp dẫn đặc biệt.',425000.00,'/CatBaBooking/uploads/dishes/9492f4ee91544761a3a58e8dafafe533.webp',1);
/*!40000 ALTER TABLE `dishes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `features`
--

DROP TABLE IF EXISTS `features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `features` (
  `feature_id` int NOT NULL AUTO_INCREMENT,
  `feature_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`feature_id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `features`
--

LOCK TABLES `features` WRITE;
/*!40000 ALTER TABLE `features` DISABLE KEYS */;
INSERT INTO `features` VALUES (1,'Trang chủ','/Home'),(2,'Danh sách Homestay','/homestay-list'),(3,'Danh sách Restaurant','/restaurant'),(4,'Chi tiết Homestay','/homestay-detail'),(5,'Chi tiết Restaurant','/restaurant-detail'),(6,'Tìm kiếm Homestay','/homestays-list'),(7,'Tìm kiếm Restaurant','/restaurants'),(8,'Thêm vào giỏ hàng','/add-to-cart'),(9,'Cập nhật số lượng giỏ hàng','/update-cart-quantity'),(10,'Cập nhật ghi chú giỏ hàng','/update-cart-notes'),(11,'Xóa khỏi giỏ hàng','/remove-from-cart'),(12,'Kiểm tra bàn trống','/check-available-table'),(13,'Thanh toán đặt bàn Restaurant','/checkout-restaurant'),(14,'Xác nhận thanh toán','/confirmation-payment'),(15,'Trạng thái thanh toán','/payment-status'),(16,'Webhook SePay','/sepay-webhook'),(17,'Hủy booking hết hạn','/cancel-expired-booking'),(18,'Đăng Nhập','/Login'),(19,'Đăng Xuất','/Logout'),(20,'Quên Mật Khẩu','/forgot-password'),(21,'Đăng kí tài khoản Owner','/register-owner'),(22,'Đăng kí tài khoản Customer','/register-customer'),(23,'Thông tin Restaurant','/restaurant-settings'),(24,'Danh sách món ăn','/list-dish'),(25,'Thêm món ăn','/add-dish'),(26,'Quản lý bàn ăn Restaurant','/restaurant-manage-tables'),(27,'Thông tin Restaurant','/restaurant-profile'),(28,'Thêm bàn','/restaurant-table-add'),(29,'Xóa bàn','/restaurant-table-delete'),(30,'Update bàn','/restaurant-table-update'),(31,'Update món ăn','/update-dish'),(32,'Xóa phòng  trong homestay','/delete-homestay-room'),(33,'Xem Chi tiết Đặt phòng','/get-homestay-booking-details'),(34,'Quản lý Phòng','/manage-homestay-rooms'),(35,'Thông tin Homestay','/homestay-settings'),(36,'Chỉnh sửa phòng','/update-homestay-room'),(37,'Bật/Tắt Trạng thái Phòng','/toggle-homestay-room-status'),(38,'Danh sách Đơn đặt phòng','/homestay-bookings'),(39,'Danh sách booking restaurant','/owner-bookings');
/*!40000 ALTER TABLE `features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `occasions`
--

DROP TABLE IF EXISTS `occasions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `occasions` (
  `occasion_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`occasion_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `occasions`
--

LOCK TABLES `occasions` WRITE;
/*!40000 ALTER TABLE `occasions` DISABLE KEYS */;
INSERT INTO `occasions` VALUES (4,'Công tác'),(5,'Nghỉ dưỡng dài ngày'),(2,'Phù hợp cho cặp đôi'),(1,'Phù hợp cho gia đình'),(3,'Phù hợp cho nhóm bạn');
/*!40000 ALTER TABLE `occasions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_method` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','completed','failed','refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gateway_response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (17,12,10000.00,'cash','failed',NULL,'\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 11:20:22','2025-11-10 03:17:04'),(18,12,10000.00,'sepay','failed',NULL,'BKD57DFCA22487\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 11:20:23','2025-11-10 03:17:04'),(19,13,10000.00,'sepay','failed',NULL,'BK125DDD122790\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 12:44:43','2025-11-10 03:17:04'),(20,14,10000.00,'sepay','failed',NULL,'BKE2E7157A1701\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 12:52:22','2025-11-10 03:17:04'),(21,15,10000.00,'sepay','failed',NULL,'BKBF4BB8894921\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 13:07:45','2025-11-10 03:17:04'),(22,17,10000.00,'sepay','failed',NULL,'BKFB53E45C9901\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 15:55:10','2025-11-10 03:17:04'),(23,18,10000.00,'sepay','failed',NULL,'BKD6EA7F494583\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 20:59:25','2025-11-10 03:17:04'),(24,19,10000.00,'sepay','failed',NULL,'BK7A9C02ED1445\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 21:17:01','2025-11-10 03:17:04'),(25,20,10000.00,'sepay','failed',NULL,'BKC6BD88D29878\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 21:24:40','2025-11-10 03:17:04'),(26,21,10000.00,'sepay','failed',NULL,'BKEED58C175946\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 21:34:06','2025-11-10 03:17:04'),(27,22,10000.00,'sepay','failed',NULL,'BK92C94D0E1205\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 21:40:21','2025-11-10 03:17:04'),(28,23,10000.00,'sepay','failed',NULL,'BKBA2851774981\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 21:44:35','2025-11-10 03:17:04'),(29,24,10000.00,'sepay','failed',NULL,'BKC3AB57C66645\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 22:41:46','2025-11-10 03:17:04'),(30,24,10000.00,'sepay','failed',NULL,'BKC3AB57C66645\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 22:41:47','2025-11-10 03:17:04'),(31,25,20000.00,'sepay','completed','669V501253110065_29369229','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-07 06:14:08\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BKAF3C7E678304\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BKAF3C7E678304\",\"transferAmount\":20000,\"referenceCode\":\"669V501253110065\",\"accumulated\":615018,\"id\":29369229}','2025-11-06 23:14:09','2025-11-06 23:13:28','2025-11-06 23:14:08'),(32,25,20000.00,'sepay','pending',NULL,'BKAF3C7E678304',NULL,'2025-11-06 23:13:28','2025-11-06 23:13:28'),(33,26,295000.00,'sepay','failed',NULL,'BKB0257BDD0648\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 23:40:40','2025-11-10 03:17:04'),(34,26,295000.00,'sepay','failed',NULL,'BKB0257BDD0648\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-06 23:40:41','2025-11-10 03:17:04'),(35,27,10000.00,'sepay','completed','669V501253110075_29370976','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-07 06:50:46\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BK94857F858031\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BK94857F858031\",\"transferAmount\":10000,\"referenceCode\":\"669V501253110075\",\"accumulated\":920018,\"id\":29370976}','2025-11-06 23:50:46','2025-11-06 23:50:28','2025-11-06 23:50:46'),(36,28,385000.00,'sepay','completed','669V501253110081_29371720','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-07 07:01:02\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BK32D799874883\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BK32D799874883\",\"transferAmount\":385000,\"referenceCode\":\"669V501253110081\",\"accumulated\":385018,\"id\":29371720}','2025-11-07 00:01:03','2025-11-07 00:00:44','2025-11-07 00:01:02'),(37,29,10000.00,'sepay','completed','669V501253110084_29372085','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-07 07:06:03\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BKA706C8B38147\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BKA706C8B38147\",\"transferAmount\":10000,\"referenceCode\":\"669V501253110084\",\"accumulated\":395018,\"id\":29372085}','2025-11-07 00:06:04','2025-11-07 00:05:28','2025-11-07 00:06:03'),(38,30,10000.00,'sepay','failed',NULL,'BKD0C04F3F5719\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-07 00:08:35','2025-11-10 03:17:04'),(39,31,10000.00,'sepay','completed','066ITC1253110486_29390673','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-07 10:06:55\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BKA6AEA0661321\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BKA6AEA0661321\",\"transferAmount\":10000,\"referenceCode\":\"066ITC1253110486\",\"accumulated\":405018,\"id\":29390673}','2025-11-07 03:06:55','2025-11-07 03:06:41','2025-11-07 03:06:54'),(40,32,20000.00,'sepay','completed','669V501253110300_29397496','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-07 11:01:11\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BKD0D8B03B8407\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BKD0D8B03B8407\",\"transferAmount\":20000,\"referenceCode\":\"669V501253110300\",\"accumulated\":425018,\"id\":29397496}','2025-11-07 04:01:11','2025-11-07 04:00:38','2025-11-07 04:01:11'),(41,33,10000.00,'sepay','failed',NULL,'BKD932BF444829\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-09 16:48:04','2025-11-10 03:17:04'),(42,34,10000.00,'sepay','failed',NULL,'BK56925F808774\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-09 16:49:28','2025-11-10 03:17:04'),(43,35,249000.00,'sepay','failed',NULL,'BK6B86D57D2584\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-09 17:21:22','2025-11-10 03:17:04'),(44,36,385000.00,'sepay','failed',NULL,'BKA8F33A524298\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-09 17:31:24','2025-11-10 03:17:04'),(45,37,249000.00,'sepay','failed',NULL,'BK5650F8035241\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-10 03:25:05','2025-11-10 03:30:29'),(46,38,10000.00,'sepay','failed',NULL,'BK4330EE025754\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-10 03:48:35','2025-11-10 03:54:29'),(47,39,10000.00,'sepay','completed','669V501253142076_29932965','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-10 18:57:43\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BKCC2F65F86941\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BKCC2F65F86941\",\"transferAmount\":10000,\"referenceCode\":\"669V501253142076\",\"accumulated\":317018,\"id\":29932965}','2025-11-10 11:57:43','2025-11-10 11:57:06','2025-11-10 11:57:43'),(48,40,249000.00,'sepay','failed',NULL,'BKC49C72366157\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-10 15:26:06','2025-11-10 15:31:12'),(49,41,10000.00,'sepay','failed',NULL,'BKE0E0CF404229\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-10 18:27:04','2025-11-10 18:32:12'),(50,42,20000.00,'sepay','completed','669V501253170958_30429473','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-13 21:14:49\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BK97285A8B3381\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BK97285A8B3381\",\"transferAmount\":20000,\"referenceCode\":\"669V501253170958\",\"accumulated\":626018,\"id\":30429473}','2025-11-13 14:14:49','2025-11-13 14:14:23','2025-11-13 14:14:49'),(51,43,10000.00,'sepay','completed','669V501253170971_30431995','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-13 21:30:36\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BKAA67E4221278\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BKAA67E4221278\",\"transferAmount\":10000,\"referenceCode\":\"669V501253170971\",\"accumulated\":636018,\"id\":30431995}','2025-11-13 14:30:37','2025-11-13 14:30:11','2025-11-13 14:30:36'),(52,44,10000.00,'sepay','completed','669V501253170972_30432321','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-13 21:32:31\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BKEE5205708644\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BKEE5205708644\",\"transferAmount\":10000,\"referenceCode\":\"669V501253170972\",\"accumulated\":646018,\"id\":30432321}','2025-11-13 14:32:31','2025-11-13 14:32:18','2025-11-13 14:32:31'),(53,45,10000.00,'sepay','completed','669V501253170989_30436514','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-13 22:00:18\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BK352DCBC83389\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BK352DCBC83389\",\"transferAmount\":10000,\"referenceCode\":\"669V501253170989\",\"accumulated\":656018,\"id\":30436514}','2025-11-13 15:00:19','2025-11-13 14:59:53','2025-11-13 15:00:18'),(54,46,10000.00,'sepay','completed','669V501253180005_30439066','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-13 22:21:07\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BK9F1ABC985437\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BK9F1ABC985437\",\"transferAmount\":10000,\"referenceCode\":\"669V501253180005\",\"accumulated\":686020,\"id\":30439066}','2025-11-13 15:21:07','2025-11-13 15:20:55','2025-11-13 15:21:07'),(55,47,259000.00,'sepay','completed','669V501253180012_30439794','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-13 22:27:14\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BK0698E0F34645\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BK0698E0F34645\",\"transferAmount\":259000,\"referenceCode\":\"669V501253180012\",\"accumulated\":945020,\"id\":30439794}','2025-11-13 15:27:14','2025-11-13 15:27:04','2025-11-13 15:27:13'),(56,48,10000.00,'sepay','completed','669V501253180015_30440104','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-13 22:29:45\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BKA5A42A733091\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BKA5A42A733091\",\"transferAmount\":10000,\"referenceCode\":\"669V501253180015\",\"accumulated\":955020,\"id\":30440104}','2025-11-13 15:29:45','2025-11-13 15:29:33','2025-11-13 15:29:44'),(57,49,10000.00,'sepay','completed','669V501253180018_30440543','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-13 22:32:54\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BKC4D7BE455073\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BKC4D7BE455073\",\"transferAmount\":10000,\"referenceCode\":\"669V501253180018\",\"accumulated\":965020,\"id\":30440543}','2025-11-13 15:32:55','2025-11-13 15:32:35','2025-11-13 15:32:55'),(58,50,10000.00,'sepay','completed','669V501253180025_30441279','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-13 22:39:12\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BK6C5166325273\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BK6C5166325273\",\"transferAmount\":10000,\"referenceCode\":\"669V501253180025\",\"accumulated\":975020,\"id\":30441279}','2025-11-13 15:39:12','2025-11-13 15:38:55','2025-11-13 15:39:12'),(59,51,1700000.00,'sepay','failed',NULL,'HSC6D2425F2502\n[AUTO] Expired - Quá 5 phút không thanh toán',NULL,'2025-11-14 01:27:52','2025-11-14 01:33:11'),(60,52,10000.00,'sepay','completed','669V501253180287_30492685','{\"gateway\":\"TPBank\",\"transactionDate\":\"2025-11-14 10:41:01\",\"accountNumber\":\"00000807297\",\"subAccount\":\"DVN\",\"code\":null,\"content\":\"TKPDVN BK12D52BD28069\",\"transferType\":\"in\",\"description\":\"BankAPINotify TKPDVN BK12D52BD28069\",\"transferAmount\":10000,\"referenceCode\":\"669V501253180287\",\"accumulated\":1005020,\"id\":30492685}','2025-11-14 03:41:01','2025-11-14 03:39:38','2025-11-14 03:41:00');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_tables`
--

DROP TABLE IF EXISTS `restaurant_tables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_tables` (
  `table_id` int NOT NULL AUTO_INCREMENT,
  `business_id` int NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `capacity` int NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`table_id`),
  KEY `business_id` (`business_id`),
  CONSTRAINT `restaurant_tables_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_tables`
--

LOCK TABLES `restaurant_tables` WRITE;
/*!40000 ALTER TABLE `restaurant_tables` DISABLE KEYS */;
INSERT INTO `restaurant_tables` VALUES (1,4,'Bàn 01',4,1),(2,4,'Bàn 02',8,1),(3,4,'Bàn 03',4,1),(4,4,'Bàn 04',4,1),(5,4,'Bàn 05',8,1),(7,4,'Bàn 06',6,1),(11,4,'Bàn 10',4,1);
/*!40000 ALTER TABLE `restaurant_tables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_types`
--

DROP TABLE IF EXISTS `restaurant_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_types` (
  `type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`type_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_types`
--

LOCK TABLES `restaurant_types` WRITE;
/*!40000 ALTER TABLE `restaurant_types` DISABLE KEYS */;
INSERT INTO `restaurant_types` VALUES (4,'Lẩu'),(1,'Nhà hàng hải sản'),(3,'Nướng BBQ'),(2,'Quán ăn địa phương');
/*!40000 ALTER TABLE `restaurant_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `business_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` tinyint NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `booking_id` (`booking_id`),
  KEY `business_id` (`business_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'customer','Khách hàng đặt homestay/nhà hàng','2025-10-02 09:58:17'),(2,'owner homestay','Chủ homestay','2025-10-02 09:58:17'),(3,'admin','Quản trị viên hệ thống','2025-10-02 09:58:17'),(4,'owner restaurant','Chủ nhà hàng','2025-10-02 09:58:17');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_features`
--

DROP TABLE IF EXISTS `roles_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles_features` (
  `role_id` int NOT NULL,
  `feature_id` int NOT NULL,
  PRIMARY KEY (`role_id`,`feature_id`),
  KEY `idx_rf_feature` (`feature_id`),
  CONSTRAINT `fk_rf_feature` FOREIGN KEY (`feature_id`) REFERENCES `features` (`feature_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rf_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_features`
--

LOCK TABLES `roles_features` WRITE;
/*!40000 ALTER TABLE `roles_features` DISABLE KEYS */;
INSERT INTO `roles_features` VALUES (1,1),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(1,17),(1,18),(2,18),(4,18),(1,19),(2,19),(4,19),(1,20),(2,20),(4,20),(1,21),(2,21),(4,21),(1,22),(2,22),(4,22),(4,23),(4,24),(4,25),(4,26),(4,27),(4,28),(4,29),(4,30),(4,31),(2,32),(2,33),(2,34),(2,35),(2,36),(2,37),(2,38),(4,39);
/*!40000 ALTER TABLE `roles_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_availability`
--

DROP TABLE IF EXISTS `room_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_availability` (
  `availability_id` bigint NOT NULL AUTO_INCREMENT,
  `room_id` int NOT NULL,
  `date` date NOT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  `status` enum('booked','blocked') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`availability_id`),
  UNIQUE KEY `room_id` (`room_id`,`date`),
  KEY `idx_room_availability` (`room_id`,`date`),
  CONSTRAINT `room_availability_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_availability`
--

LOCK TABLES `room_availability` WRITE;
/*!40000 ALTER TABLE `room_availability` DISABLE KEYS */;
INSERT INTO `room_availability` VALUES (1,1,'2025-10-14',850000.00,'booked'),(2,1,'2025-10-28',850000.00,'booked'),(3,1,'2025-10-29',850000.00,'booked'),(4,4,'2025-10-29',250000.00,'booked'),(5,4,'2025-10-28',250000.00,'booked'),(6,2,'2025-10-28',850000.00,'booked'),(7,2,'2025-10-29',850000.00,'booked'),(8,1,'2025-11-15',850000.00,'booked'),(9,1,'2025-11-16',850000.00,'booked');
/*!40000 ALTER TABLE `room_availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_images`
--

DROP TABLE IF EXISTS `room_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `room_id` int NOT NULL,
  `image_url` varchar(500) NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `room_images_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_images`
--

LOCK TABLES `room_images` WRITE;
/*!40000 ALTER TABLE `room_images` DISABLE KEYS */;
INSERT INTO `room_images` VALUES (1,1,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/733132235.jpg?k=651e0dc21e3855a50d1bf760010c0653a300c01b0ce6c354df8a047da1c6537f&o=&hp=1'),(2,1,'https://khudothixanhvn.com/wp-content/uploads/2023/03/homestay-ecopark-banner-01.jpg');
/*!40000 ALTER TABLE `room_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `business_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `capacity` int NOT NULL,
  `price_per_night` decimal(12,2) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`room_id`),
  KEY `business_id` (`business_id`),
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,2,'Phòng Đôi View Biển',2,850000.00,1),(2,2,'Phòng cạnh biển',4,1400000.00,1),(5,27,'phòng vip',2,350000.00,1),(6,27,'phòng thường',2,250000.00,1),(7,27,'phòng thường',4,250000.00,1),(8,27,'phong vip',4,400000.00,1);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_availability`
--

DROP TABLE IF EXISTS `table_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `table_availability` (
  `availability_id` bigint NOT NULL AUTO_INCREMENT,
  `table_id` int NOT NULL,
  `reservation_date` date NOT NULL,
  `reservation_time` time NOT NULL,
  `status` enum('booked','blocked') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`availability_id`),
  UNIQUE KEY `table_id` (`table_id`,`reservation_date`,`reservation_time`),
  KEY `idx_table_availability` (`table_id`,`reservation_date`,`reservation_time`),
  CONSTRAINT `table_availability_ibfk_1` FOREIGN KEY (`table_id`) REFERENCES `restaurant_tables` (`table_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_availability`
--

LOCK TABLES `table_availability` WRITE;
/*!40000 ALTER TABLE `table_availability` DISABLE KEYS */;
INSERT INTO `table_availability` VALUES (39,1,'2025-11-13','12:30:00','booked'),(40,3,'2025-11-13','11:30:00','booked'),(41,1,'2025-11-13','21:30:00','booked'),(42,3,'2025-11-13','20:00:00','booked'),(43,4,'2025-11-13','20:30:00','booked'),(44,11,'2025-11-13','21:30:00','booked'),(45,7,'2025-11-13','21:30:00','booked'),(46,1,'2025-11-20','20:30:00','booked'),(47,1,'2025-11-24','21:30:00','booked'),(48,1,'2025-11-14','20:00:00','booked');
/*!40000 ALTER TABLE `table_availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp_carts`
--

DROP TABLE IF EXISTS `temp_carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temp_carts` (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `business_id` int NOT NULL,
  `dish_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `notes` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_id`),
  UNIQUE KEY `unique_cart_item` (`user_id`,`business_id`,`dish_id`),
  KEY `idx_user_business` (`user_id`,`business_id`),
  KEY `temp_carts_ibfk_2` (`business_id`),
  KEY `temp_carts_ibfk_3` (`dish_id`),
  CONSTRAINT `temp_carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `temp_carts_ibfk_2` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  CONSTRAINT `temp_carts_ibfk_3` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`dish_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_carts`
--

LOCK TABLES `temp_carts` WRITE;
/*!40000 ALTER TABLE `temp_carts` DISABLE KEYS */;
/*!40000 ALTER TABLE `temp_carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `citizen_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `personal_address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','pending','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_role_status` (`role_id`,`status`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,3,'Admin System','catbabooking.fms@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$jnBkck/Ugu9U8hdy3nQyog$HRFQLnfUzMvaG6Hu4ZUY1aJbq0H7Ut3Hz1zwJbInCWI',NULL,NULL,NULL,'active','2025-10-02 09:58:45','2025-10-02 09:58:45'),(2,1,'Đào Văn Năng','nangdvhe187101@fpt.edu.vn','$argon2id$v=19$m=19456,t=2,p=1$0ozWtw9y3zdXMJsLTOZycg$j3JDQoxeTUn2ngKtzVj94rlzbIKpaAtwLgcuAL5Ex+k',NULL,NULL,NULL,'active','2025-10-02 09:59:53','2025-10-13 15:27:46'),(3,1,'abcc','hieu2406nh@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$tC6CV9jq5BH0jRI1qGT21w$3n5gF6BXfUqJWIAshdAxPGIGZUmFvP2IRVhSZkYpfJY',NULL,NULL,NULL,'active','2025-10-10 03:40:59','2025-10-10 03:40:59'),(4,1,'Nguyễn Trung HIếu','hieu2406ny@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$fM/6793lmUjw5jABVwSswQ$CfKugo8256OBGttFdI/FTob+IgoI08BH5ShbO3NxpLM',NULL,NULL,NULL,'active','2025-10-10 03:48:18','2025-10-10 03:48:18'),(6,2,'Nguyễn Trung Hiếu','Hieunthe187126@fpt.edu.vn','$argon2id$v=19$m=19456,t=2,p=1$YhVw61c9duTcUbL7dTVccQ$n+lHI6ZvPd6npy1wllqFqdWYCDzQATllbAGNf0xUdSY','0796034672','012345678910','phú thọ','active','2025-10-10 03:52:38','2025-10-13 15:25:27'),(7,2,'nguyen van a','aacsasdc@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$qqid7TgWuVC88eGDX75q9g$4fZcTRLNuh92SjzM2znHtl+5wy2zDXDNBMi6a4vnnBA','01223412334','122324234234','aaaa','active','2025-10-14 06:02:54','2025-10-14 06:03:44'),(8,4,'Phạm Vy','phamthituongvy30112004@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$M+8p2m/bQyBuTvqnmqS1GQ$w1993ltz7ilqxWz4+29n/8I5oRr8Bewe+pL0NusHwiY','0987654323','035204338866','Hà Nam','active','2025-10-21 12:58:53','2025-11-12 18:34:53'),(9,2,'Ninh Hong','ninhhong@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$mr9Wp2XI37B1RyqJJ8HmbA$TJIkaOyFi5fc573tiHfsQvC2ZGTB93nU7fzLG7B4mLU','09876412123','123456789012','hà nội','active','2025-10-15 01:14:36','2025-10-15 01:25:56'),(10,2,'Hoàng Thị Lan','lan@gmail.com','$argon2id$dummy','09874124142','091234123123','Cao Bằng','active','2025-10-15 01:19:10','2025-10-15 01:26:03'),(11,2,'nguyen van b','chub@gmail.com','$argon2id$dummy','0124124112','1231231231231','350 Hà Sen, thị trấn Cát Bà','active','2025-10-15 01:21:32','2025-10-15 01:26:10'),(12,2,'Jerry','Jerry@gmail.com','$argon2id$dummy','01248124124','1231283129783','Cát Bà','rejected','2025-10-15 01:23:35','2025-10-31 00:54:31'),(13,2,'nguy van an','GreenHomestay@gmail.com','$argon2id$dummy','0987645112','8989723423423','Cát Bà','rejected','2025-10-15 01:25:26','2025-10-31 00:54:34'),(14,2,'Lý Thị Kiều','lythikieu@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$TBwvz092wLKTTW0Cm5SQFg$AkY3eCQi8TF8YxTiJRG1IG3yflAANNk1Ydwgcx3BymY','0987654333','035204338810','Cát Bà','active','2025-10-29 19:36:55','2025-10-31 04:38:03'),(17,2,'Lý Thị Thảo','lythithao@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$ZHK5OSOdmaNzsBxJxS4cTQ$7KPBRTG5NW0DOU9Gy91J7UH6tlBGeYs1oj+ltG/ckp8','098765412','035204338800','Cát Bà','rejected','2025-10-31 04:41:37','2025-10-31 04:42:06'),(18,2,'Nguyễn Ngọc Bảo','nguyenngocbao@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$S1MECaXDZa1drrWM5HXxvA$bR4O9r/4IYWNaLGUs9TmNj9OOfYVnl7frwIds548zus','0987654328','035204338886','Hà Nam','active','2025-10-31 04:44:08','2025-11-12 18:29:33'),(19,1,'Nguyễn Nhật Minh','nangdz14@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$B/wL6KG60JYs3Huy+VCIAQ$5f3j2HJN1whICEHzO/ywjcFYL/cut9XS4XpRU0chv40',NULL,NULL,NULL,'active','2025-11-06 21:23:46','2025-11-06 21:23:46'),(20,4,'Nguyễn Huy Thiệp','nguyenhuythiep@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$T9OzkQn+0gyNfV9MTY5XPQ$RrOvybRhBQqA8lNmqvlEaokzTqMzhMSqJF8AzsaPIP8','0987686868','035862807777','Hà Tĩnh','active','2025-11-07 03:42:13','2025-11-12 22:34:42'),(21,4,'Nguyễn Huy Đức','nguyenhuyduc@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$fwivzTkocxEWS4zj9B7qiA$7rItj6ThAIQxEEpekb/az5lZDNk7e1oK4rZ5nBTE4Co','0987171717','035862801111','Hà Nội','pending','2025-11-10 14:00:48','2025-11-12 17:54:07'),(22,4,'Nguyễn Huy ','nguyenhuy@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$ypA8X3fXxWNfdo6e5dz+Mw$2A+ubQ50H+oK8PGR/jOJZeowadhNOdaa34Ul5CoccqQ','0987654321','035204338844','Hà Nội','pending','2025-11-12 17:49:57','2025-11-12 17:49:57');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-14 17:22:09
