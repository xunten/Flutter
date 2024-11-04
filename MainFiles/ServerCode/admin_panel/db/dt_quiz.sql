-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 01, 2023 at 03:22 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dt_quiz_clean`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_admin`
--

CREATE TABLE `tbl_admin` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `type` int(11) NOT NULL COMMENT '1 = All Access	',
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_admin`
--

INSERT INTO `tbl_admin` (`id`, `username`, `email`, `password`, `type`, `status`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin@admin.com', '$2y$10$99NpPV/TfRDezCD/acNij.jbDe0yIDiDKXLEpF7p2LmJSkPLQVWES', 1, 1, '2023-05-08 05:12:06', '2023-08-23 10:51:42');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_audio_leaderboard`
--

CREATE TABLE `tbl_audio_leaderboard` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `total_questions` varchar(255) NOT NULL,
  `questions_attended` varchar(255) NOT NULL,
  `correct_answers` varchar(255) NOT NULL,
  `score` float NOT NULL,
  `is_win_point` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_audio_question`
--

CREATE TABLE `tbl_audio_question` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` int(11) NOT NULL,
  `question` text NOT NULL,
  `question_type` int(11) NOT NULL COMMENT '1= normal, 2= true/false',
  `option_a` text NOT NULL,
  `option_b` text NOT NULL,
  `option_c` text NOT NULL,
  `option_d` text NOT NULL,
  `audio_type` varchar(255) NOT NULL COMMENT 'server_video, external_url',
  `audio` varchar(255) NOT NULL,
  `answer` text NOT NULL,
  `image` varchar(255) NOT NULL,
  `note` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_category`
--

CREATE TABLE `tbl_category` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `image` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_classification`
--

CREATE TABLE `tbl_classification` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `level_name` varchar(255) NOT NULL,
  `level_order` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_contest`
--

CREATE TABLE `tbl_contest` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `type` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `image` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `no_of_user` int(11) NOT NULL,
  `no_of_user_prize` int(11) NOT NULL,
  `no_of_rank` int(11) NOT NULL,
  `total_prize` int(11) NOT NULL,
  `prize_json` text NOT NULL,
  `status` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_contest_save_report`
--

CREATE TABLE `tbl_contest_save_report` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `contest_id` int(11) NOT NULL,
  `total_questions` varchar(255) NOT NULL,
  `questions_attended` varchar(255) NOT NULL,
  `correct_answers` varchar(255) NOT NULL,
  `score` float NOT NULL,
  `question_json` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_daily_quiz_leaderboard`
--

CREATE TABLE `tbl_daily_quiz_leaderboard` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `total_questions` varchar(255) NOT NULL,
  `questions_attended` varchar(255) NOT NULL,
  `correct_answers` varchar(255) NOT NULL,
  `score` float NOT NULL,
  `is_win_point` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_daily_quiz_question`
--

CREATE TABLE `tbl_daily_quiz_question` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `question` text NOT NULL,
  `question_type` int(11) NOT NULL COMMENT '1= normal, 2= true/false',
  `option_a` text NOT NULL,
  `option_b` text NOT NULL,
  `option_c` text NOT NULL,
  `option_d` text NOT NULL,
  `answer` text NOT NULL,
  `image` varchar(255) NOT NULL,
  `note` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_earnpoint_setting`
--

CREATE TABLE `tbl_earnpoint_setting` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `type` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_earnpoint_setting`
--

INSERT INTO `tbl_earnpoint_setting` (`id`, `key`, `value`, `type`, `created_at`, `updated_at`) VALUES
(1, 'Level', '0', 1, '2022-03-28 05:42:38', '2023-09-01 13:20:26'),
(2, 'Registration', '0', 2, '2022-03-28 05:42:49', '2023-09-01 13:20:26'),
(3, 'ReferUser', '0', 3, '2022-03-28 05:42:57', '2023-09-01 13:20:26');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_earn_point`
--

CREATE TABLE `tbl_earn_point` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `type` int(11) NOT NULL,
  `point_type` int(11) NOT NULL DEFAULT 1 COMMENT '1- Spin wheel , 2 - Daily Login point , 3- get free coin',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_earn_point`
--

INSERT INTO `tbl_earn_point` (`id`, `key`, `value`, `type`, `point_type`, `created_at`, `updated_at`) VALUES
(1, '1', '0', 1, 1, '2022-03-28 05:26:11', '2023-09-01 13:20:42'),
(2, '2', '0', 2, 1, '2022-03-28 05:26:11', '2023-09-01 13:20:42'),
(3, '3', '0', 3, 1, '2022-03-28 05:26:11', '2023-09-01 13:20:42'),
(4, '4', '0', 4, 1, '2022-03-28 05:26:11', '2023-09-01 13:20:42'),
(5, '5', '0', 5, 1, '2022-03-28 05:26:11', '2023-09-01 13:20:42'),
(6, '6', '0', 6, 1, '2022-03-28 05:26:11', '2023-09-01 13:20:42'),
(7, 'Day-1', '0', 7, 2, '2022-03-28 05:26:11', '2023-09-01 13:20:56'),
(8, 'Day-2', '0', 8, 2, '2022-03-28 05:26:11', '2023-09-01 13:20:56'),
(9, 'Day-3', '0', 9, 2, '2022-03-28 05:26:11', '2023-09-01 13:20:56'),
(10, 'Day-4', '0', 10, 2, '2022-03-28 05:26:11', '2023-09-01 13:20:56'),
(11, 'Day-5', '0', 11, 2, '2022-03-28 05:26:11', '2023-09-01 13:20:56'),
(12, 'Day-6', '0', 12, 2, '2022-03-28 05:26:11', '2023-09-01 13:20:56'),
(13, 'Day-7', '0', 13, 2, '2022-03-28 05:26:11', '2023-09-01 13:20:56'),
(14, 'free-coin', '0', 14, 3, '2022-03-28 05:26:11', '2023-09-01 13:21:06');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_earn_transaction`
--

CREATE TABLE `tbl_earn_transaction` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `contest_id` int(11) NOT NULL,
  `type` int(11) NOT NULL COMMENT '1- contest, 2- normal quiz, 3- audio quiz, 4- video quiz, 5- true/false quiz, 6- daily quiz',
  `point` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_general_setting`
--

CREATE TABLE `tbl_general_setting` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_general_setting`
--

INSERT INTO `tbl_general_setting` (`id`, `key`, `value`, `created_at`, `updated_at`) VALUES
(1, 'app_name', 'DTQuiz', '2022-03-28 05:43:41', '2023-06-02 14:03:21'),
(2, 'host_email', 'supprot@divintechs.com', '2022-03-28 05:43:45', '2023-06-16 10:43:31'),
(3, 'app_desripation', 'DivineTechs, a top web & mobile app development company offering innovative solutions for diverse industry verticals. We have creative and dedicated group of developers who are mastered in Apps Developments and Web Development with a nice in delivering quality solutions to customers across the globe.', '2022-03-28 05:43:47', '2023-09-01 13:19:46'),
(4, 'app_logo', '731692787829.jpg', '2022-03-28 05:43:50', '2023-08-23 10:50:29'),
(5, 'app_version', '1.0', '2022-03-28 05:43:54', '2023-06-13 05:16:04'),
(6, 'author', 'Divintechs', '2022-03-28 05:43:56', '2023-06-16 10:43:31'),
(7, 'contact', '+918745120369', '2022-03-28 05:43:59', '2023-06-16 10:43:31'),
(8, 'email', 'supprot@divintechs.com', '2022-03-28 05:44:04', '2023-06-16 10:43:31'),
(9, 'website', 'www.website.com', '2022-03-28 05:44:07', '2023-06-13 05:16:04'),
(11, 'publisher_id', '', '2022-03-28 05:44:11', '2022-06-06 04:13:08'),
(12, 'banner_ad', '0', '2022-03-28 05:44:14', '2023-08-23 10:58:03'),
(13, 'banner_adid', '', '2022-03-28 05:44:16', '2023-08-23 10:58:03'),
(14, 'interstital_ad', '0', '2022-03-28 05:44:19', '2023-08-23 10:58:03'),
(15, 'interstital_adid', '', '2022-03-28 05:44:22', '2023-08-23 10:58:03'),
(16, 'interstital_adclick', '', '2022-03-28 05:44:24', '2023-08-23 10:58:03'),
(17, 'onesignal_apid', '', '2022-03-28 05:44:28', '2023-08-23 09:06:39'),
(18, 'onesignal_rest_key', '', '2022-03-28 05:44:30', '2023-08-23 09:06:39'),
(19, 'reward_ad', '0', '2022-03-28 05:44:34', '2023-08-23 10:58:03'),
(20, 'reward_adid', '', '2022-03-28 05:44:36', '2023-08-23 10:58:03'),
(21, 'reward_adclick', '', '2022-03-28 05:44:39', '2023-08-23 10:58:03'),
(24, 'earning_point', '0', '2022-03-28 05:44:51', '2023-09-01 13:20:14'),
(25, 'earning_amount', '0', '2022-03-28 05:44:54', '2023-09-01 13:20:14'),
(26, 'min_earning_point', '0', '2022-03-28 05:45:11', '2023-09-01 13:20:14'),
(27, 'currency', 'INR', '2022-03-28 05:45:16', '2023-06-13 05:17:33'),
(29, 'total_score', '100', '2022-03-28 05:45:21', '2022-03-28 05:45:23'),
(30, 'total_score_point', '100', '2022-03-28 05:45:25', '2022-03-28 05:45:28'),
(32, 'native_adid', '', '2022-03-28 05:45:31', '2023-09-01 13:15:16'),
(35, 'fb_native_status', '0', '2022-03-28 05:45:40', '2023-08-23 11:14:25'),
(36, 'fb_interstiatial_id', '', '2022-03-28 05:45:43', '2023-08-23 11:14:25'),
(37, 'fb_rewardvideo_id', '', '2022-03-28 05:45:46', '2023-08-23 11:14:25'),
(38, 'fb_native_id', '', '2022-03-28 05:45:49', '2023-08-23 11:14:25'),
(39, 'fb_banner_id', '', '2022-03-28 05:45:52', '2023-08-23 11:14:25'),
(40, 'fb_native_full_id', '', '2022-03-28 05:45:56', '2023-08-23 11:14:25'),
(51, 'fb_banner_status', '0', '2022-03-28 05:46:30', '2023-08-23 11:14:25'),
(52, 'fb_interstiatial_status', '0', '2022-03-28 05:46:33', '2023-08-23 11:14:25'),
(53, 'fb_rewardvideo_status', '0', '2022-03-29 05:46:35', '2023-08-23 11:14:25'),
(54, 'fb_native_full_status', '0', '2022-03-28 05:46:38', '2023-08-23 11:14:25'),
(55, 'daily_refer_limit', '0', '2022-03-28 05:46:42', '2023-09-01 13:20:14'),
(56, 'wallet_withdraw_visibility', 'no', '2022-03-28 05:46:45', '2023-09-01 13:20:14'),
(57, 'currency_code', '₹', '2022-03-28 05:46:47', '2023-05-26 11:01:16'),
(59, 'fb_ios_native_status', '0', '2022-06-01 06:34:31', '2023-08-23 11:14:56'),
(60, 'fb_ios_banner_status', '0', '2022-06-01 06:34:31', '2023-08-23 11:14:56'),
(61, 'fb_ios_interstiatial_status', '0', '2022-06-01 06:34:31', '2023-08-23 11:14:56'),
(62, 'fb_ios_rewardvideo_status', '0', '2022-06-01 06:34:31', '2023-08-23 11:14:56'),
(63, 'fb_ios_native_full_status', '0', '2022-06-01 06:34:31', '2023-08-23 11:14:56'),
(64, 'fb_ios_native_id', '', '2022-06-01 06:41:38', '2023-08-23 11:14:56'),
(65, 'fb_ios_banner_id', '', '2022-06-01 06:41:38', '2023-08-23 11:14:56'),
(66, 'fb_ios_interstiatial_id', '', '2022-06-01 06:41:38', '2023-08-23 11:14:56'),
(67, 'fb_ios_rewardvideo_id', '', '2022-06-01 06:41:38', '2023-08-23 11:15:01'),
(68, 'fb_ios_native_full_id', '', '2022-06-01 06:41:38', '2023-08-23 11:15:01'),
(69, 'ios_banner_ad', '0', '2022-06-01 07:33:28', '2023-08-23 10:59:39'),
(70, 'ios_banner_adid', '', '2022-06-01 07:33:28', '2023-08-23 10:59:39'),
(71, 'ios_interstital_ad', '0', '2022-06-01 07:33:28', '2023-08-23 10:59:39'),
(72, 'ios_interstital_adid', '', '2022-06-01 07:33:28', '2023-08-23 10:59:39'),
(73, 'ios_interstital_adclick', '', '2022-06-01 07:33:28', '2023-08-23 10:59:39'),
(74, 'ios_reward_ad', '0', '2022-06-01 07:33:28', '2023-08-23 10:59:39'),
(75, 'ios_reward_adid', '', '2022-06-01 07:33:28', '2023-08-23 10:59:39'),
(76, 'ios_reward_adclick', '', '2022-06-01 07:33:28', '2023-08-23 10:59:39');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_languages`
--

CREATE TABLE `tbl_languages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `language` varchar(255) NOT NULL,
  `lang_code` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_languages`
--

INSERT INTO `tbl_languages` (`id`, `language`, `lang_code`, `status`, `created_at`, `updated_at`) VALUES
(1, 'English', 'en', 1, '2022-03-28 05:06:55', '2023-08-21 05:11:50'),
(2, 'हिन्दी', 'hi', 0, '2022-03-28 05:06:55', '2023-08-21 05:11:50'),
(3, 'ગુજરાતી', 'guj', 0, '2022-03-28 05:06:55', '2023-05-08 09:44:28'),
(4, 'عربي', 'ar', 0, '2022-03-28 05:06:55', '2023-06-05 11:03:32');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_level`
--

CREATE TABLE `tbl_level` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `level_order` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  `win_question_count` int(11) NOT NULL,
  `total_question` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_menu`
--

CREATE TABLE `tbl_menu` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_menu`
--

INSERT INTO `tbl_menu` (`id`, `name`, `status`, `created_at`, `updated_at`) VALUES
(1, 'dashboard', 1, '2023-06-05 10:12:56', '2023-06-19 05:03:54'),
(2, 'user', 1, '2023-06-05 10:15:27', '2023-06-05 10:27:14'),
(3, 'category', 1, '2023-06-05 10:15:27', '2023-06-05 10:30:13'),
(4, 'level', 1, '2023-06-05 10:15:27', '2023-06-05 10:30:37'),
(5, 'classification', 1, '2023-06-05 10:15:27', '2023-06-05 10:30:44'),
(6, 'page', 1, '2023-06-05 10:15:27', '2023-06-05 10:30:46'),
(7, 'pratice question', 1, '2023-06-05 10:15:27', '2023-06-05 10:21:02'),
(8, 'normal question', 1, '2023-06-05 10:15:27', '2023-06-05 10:21:01'),
(9, 'audio question', 1, '2023-06-05 10:15:27', '2023-06-05 10:20:59'),
(10, 'video question', 1, '2023-06-05 10:15:27', '2023-06-05 10:20:58'),
(11, 'true/false question', 1, '2023-06-05 10:15:27', '2023-06-05 10:20:57'),
(12, 'daily quiz question', 1, '2023-06-05 10:19:57', '2023-06-05 10:36:24'),
(13, 'pratice leaderboard', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:55'),
(14, 'normal leaderboard', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:54'),
(15, 'audio leaderboard', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:53'),
(16, 'video leaderboard', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:52'),
(17, 'true/false leaderboard', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:51'),
(18, 'daily quiz leaderboard', 1, '2023-06-05 10:19:57', '2023-06-05 10:51:09'),
(19, 'contest list', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:46'),
(20, 'contest question', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:45'),
(21, 'one to one list', 0, '2023-06-05 10:19:57', '2023-08-21 04:19:22'),
(22, 'one to one leaderboard', 0, '2023-06-05 10:19:57', '2023-08-21 04:19:24'),
(23, 'withdrawal', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:42'),
(24, 'notification', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:41'),
(25, 'package', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:40'),
(26, 'transaction', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:38'),
(27, 'payment', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:36'),
(28, 'general setting', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:35'),
(29, 'earning setting', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:34'),
(30, 'quiz configuration', 1, '2023-06-05 10:19:57', '2023-06-05 10:20:32');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_notification`
--

CREATE TABLE `tbl_notification` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `image` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_one_to_one_challenge`
--

CREATE TABLE `tbl_one_to_one_challenge` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `room_id` varchar(255) NOT NULL,
  `category_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `c_user_id` int(11) NOT NULL,
  `j_user_id` int(11) NOT NULL DEFAULT 0,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `total_question` varchar(255) NOT NULL,
  `is_paid` int(11) NOT NULL COMMENT '0- No , 1- Yes',
  `point` varchar(255) NOT NULL DEFAULT '0',
  `is_full` int(11) NOT NULL DEFAULT 0,
  `question_ids` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_one_to_one_leaderboard`
--

CREATE TABLE `tbl_one_to_one_leaderboard` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `room_id` varchar(255) NOT NULL,
  `winning_amount` varchar(255) NOT NULL DEFAULT '0',
  `w_user_id` int(11) NOT NULL,
  `l_user_id` int(11) NOT NULL,
  `status` int(11) NOT NULL COMMENT '0- Draw , 1- Completed , 2- Not Completed',
  `date` date NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_one_to_one_save_report`
--

CREATE TABLE `tbl_one_to_one_save_report` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `room_id` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total_question` varchar(255) NOT NULL,
  `correct_answers` varchar(255) NOT NULL,
  `question_json` text NOT NULL,
  `date` datetime(6) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_package`
--

CREATE TABLE `tbl_package` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `price` int(11) NOT NULL,
  `image` varchar(255) NOT NULL,
  `currency_type` varchar(255) NOT NULL,
  `point` varchar(255) NOT NULL,
  `android_product_package` varchar(255) NOT NULL,
  `ios_product_package` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_delete` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_page`
--

CREATE TABLE `tbl_page` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `page_name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `icon` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_page`
--

INSERT INTO `tbl_page` (`id`, `page_name`, `title`, `description`, `icon`, `status`, `created_at`, `updated_at`) VALUES
(1, 'about-us', 'About Us', '<p><b><u>About -Us</u></b></p>', '', 1, '2023-01-27 10:19:52', '2023-09-01 13:15:56'),
(2, 'privacy-policy', 'Privacy Policy', '<p><font color=\"#000000\"><b><u>Privacy Policy</u></b></font></p>', '', 1, '2023-01-27 10:19:52', '2023-05-26 11:51:19'),
(3, 'terms-and-conditions', 'terms & conditions', '<p><b><u>Terms &amp; Conditions</u></b><br></p>', '', 1, '2023-01-27 10:19:52', '2023-05-26 11:50:12'),
(4, 'refund-policy', 'Refund Policy', '<p><b><u>Refund Policy</u></b></p>', '', 1, '2023-01-27 13:14:32', '2023-05-26 11:50:30');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_payment_option`
--

CREATE TABLE `tbl_payment_option` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `visibility` varchar(255) NOT NULL,
  `is_live` varchar(255) NOT NULL,
  `key_1` varchar(255) NOT NULL,
  `key_2` varchar(255) NOT NULL,
  `key_3` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_payment_option`
--

INSERT INTO `tbl_payment_option` (`id`, `name`, `visibility`, `is_live`, `key_1`, `key_2`, `key_3`, `created_at`, `updated_at`) VALUES
(1, 'inapppurchage', '0', '0', '', '', '', '2023-01-27 10:19:52', '2023-08-23 10:41:07'),
(2, 'paypal', '0', '0', '', '', '', '2023-01-27 10:19:52', '2023-08-23 10:41:14'),
(3, 'razorpay', '0', '0', '', '', '', '2023-01-27 10:19:52', '2023-08-23 10:41:49'),
(4, 'flutterwave', '0', '0', '', '', '', '2023-01-27 10:19:52', '2023-08-23 10:41:51'),
(5, 'payumoney', '0', '0', '', '', '', '2023-01-27 10:19:52', '2023-08-23 10:41:59'),
(6, 'paytm', '0', '0', '', '', '', '2023-01-27 10:19:52', '2023-08-23 10:41:55'),
(7, 'stripe', '0', '0', '', '', '', '2023-08-23 10:40:50', '2023-08-23 10:42:02');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pratice_leaderboard`
--

CREATE TABLE `tbl_pratice_leaderboard` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `question_level_master_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `total_questions` varchar(255) NOT NULL,
  `questions_attended` varchar(255) NOT NULL,
  `correct_answers` varchar(255) NOT NULL,
  `score` double(8,2) NOT NULL,
  `is_unlock` int(11) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pratice_question`
--

CREATE TABLE `tbl_pratice_question` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL DEFAULT 0,
  `level_id` int(11) NOT NULL,
  `question_level_master_id` int(11) NOT NULL DEFAULT 0,
  `image` varchar(255) NOT NULL,
  `question` text NOT NULL,
  `question_type` int(11) NOT NULL COMMENT '1= normal, 2= true/false',
  `option_a` text NOT NULL,
  `option_b` text NOT NULL,
  `option_c` text NOT NULL,
  `option_d` text NOT NULL,
  `answer` text NOT NULL,
  `note` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_question`
--

CREATE TABLE `tbl_question` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` int(11) NOT NULL,
  `contest_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL DEFAULT 0,
  `question_level_master_id` int(11) NOT NULL DEFAULT 0,
  `image` varchar(255) NOT NULL,
  `question` text NOT NULL,
  `question_type` int(11) NOT NULL COMMENT '1= normal, 2= true/false',
  `option_a` text NOT NULL,
  `option_b` text NOT NULL,
  `option_c` text NOT NULL,
  `option_d` text NOT NULL,
  `answer` text NOT NULL,
  `note` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_question_leaderboard`
--

CREATE TABLE `tbl_question_leaderboard` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `question_level_master_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `total_questions` varchar(255) NOT NULL,
  `questions_attended` varchar(255) NOT NULL,
  `correct_answers` varchar(255) NOT NULL,
  `score` double(8,2) NOT NULL,
  `is_unlock` int(11) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_quiz_configuration`
--

CREATE TABLE `tbl_quiz_configuration` (
  `id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_quiz_configuration`
--

INSERT INTO `tbl_quiz_configuration` (`id`, `key`, `value`, `created_at`, `updated_at`) VALUES
(1, 'audio_question', '0', '2023-06-02 13:32:02', '2023-09-01 13:21:41'),
(2, 'min_audio_percentage', '0', '2023-06-02 13:33:06', '2023-09-01 13:21:41'),
(3, 'audio_win_point', '0', '2023-06-02 13:33:21', '2023-09-01 13:21:41'),
(4, 'video_question', '0', '2023-06-02 13:33:06', '2023-09-01 13:21:41'),
(5, 'min_video_percentage', '0', '2023-06-02 13:33:06', '2023-09-01 13:21:41'),
(6, 'video_win_point', '0', '2023-06-02 13:33:21', '2023-09-01 13:21:41'),
(7, 'true_false_question', '0', '2023-06-02 13:32:02', '2023-09-01 13:21:41'),
(8, 'min_true_false_percentage', '0', '2023-06-02 13:33:06', '2023-09-01 13:21:41'),
(9, 'true_false_win_point', '0', '2023-06-02 13:33:21', '2023-09-01 13:21:41'),
(10, 'daily_quiz_question', '0', '2023-06-02 13:32:02', '2023-09-01 13:21:41'),
(11, 'min_daily_quiz_percentage', '0', '2023-06-02 13:33:06', '2023-09-01 13:21:41'),
(12, 'daily_quiz_win_point', '0', '2023-06-02 13:33:21', '2023-09-01 13:21:41');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_refer_earn_transaction`
--

CREATE TABLE `tbl_refer_earn_transaction` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `parent_user_id` int(11) NOT NULL,
  `child_user_id` int(11) NOT NULL,
  `reference_code` varchar(255) NOT NULL,
  `parent_user_referred_point` float(8,2) NOT NULL,
  `child_user_earned_point` float(8,2) NOT NULL,
  `earn_point_type` int(11) NOT NULL,
  `refered_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_reward_transaction`
--

CREATE TABLE `tbl_reward_transaction` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `reward_points` varchar(255) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0 COMMENT '0-Daily,1-Spin to win',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_smtp_setting`
--

CREATE TABLE `tbl_smtp_setting` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `protocol` varchar(255) NOT NULL,
  `host` varchar(255) NOT NULL,
  `port` varchar(255) NOT NULL,
  `user` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `from_name` varchar(255) NOT NULL,
  `from_email` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_smtp_setting`
--

INSERT INTO `tbl_smtp_setting` (`id`, `protocol`, `host`, `port`, `user`, `pass`, `from_name`, `from_email`, `status`, `created_at`, `updated_at`) VALUES
(1, 'smtp123', 'smtp.gmail.com', '587', 'admin@admin.com', 'admin', 'DTQuiz-Divintechs', 'admin@admin.com', 0, '2023-08-23 11:25:08', '2023-08-24 06:18:17');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_social_link`
--

CREATE TABLE `tbl_social_link` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `url` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_transaction`
--

CREATE TABLE `tbl_transaction` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `plan_subscription_id` int(11) NOT NULL,
  `transaction_id` varchar(255) NOT NULL DEFAULT '',
  `transaction_amount` varchar(255) NOT NULL,
  `point` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_true_false_leaderboard`
--

CREATE TABLE `tbl_true_false_leaderboard` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `total_questions` varchar(255) NOT NULL,
  `questions_attended` varchar(255) NOT NULL,
  `correct_answers` varchar(255) NOT NULL,
  `score` float NOT NULL,
  `is_win_point` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_true_false_question`
--

CREATE TABLE `tbl_true_false_question` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` int(11) NOT NULL,
  `question` text NOT NULL,
  `option_a` text NOT NULL,
  `option_b` text NOT NULL,
  `answer` text NOT NULL,
  `image` varchar(255) NOT NULL,
  `note` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE `tbl_user` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` text NOT NULL,
  `fullname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `mobile_number` varchar(255) NOT NULL,
  `profile_img` varchar(255) NOT NULL,
  `type` int(11) NOT NULL COMMENT '1- Normal , 2- Google, 3- OTP, 4- Apple',
  `instagram_url` text NOT NULL,
  `facebook_url` text NOT NULL,
  `twitter_url` text NOT NULL,
  `biodata` text NOT NULL,
  `address` text NOT NULL,
  `reference_code` varchar(255) NOT NULL,
  `parent_reference_code` varchar(255) NOT NULL,
  `pratice_quiz_score` int(11) NOT NULL DEFAULT 0,
  `total_score` int(11) NOT NULL DEFAULT 0,
  `total_points` int(11) NOT NULL DEFAULT 0,
  `device_type` int(11) NOT NULL DEFAULT 0 COMMENT '1 = Android, 2 = IOS',
  `device_token` text NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT '1',
  `is_updated` int(11) NOT NULL DEFAULT 0 COMMENT '0- No,1- Yes',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_notification_tracking`
--

CREATE TABLE `tbl_user_notification_tracking` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `notification_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_video_leaderboard`
--

CREATE TABLE `tbl_video_leaderboard` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `total_questions` varchar(255) NOT NULL,
  `questions_attended` varchar(255) NOT NULL,
  `correct_answers` varchar(255) NOT NULL,
  `score` float NOT NULL,
  `is_win_point` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_video_question`
--

CREATE TABLE `tbl_video_question` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` int(11) NOT NULL,
  `question` text NOT NULL,
  `question_type` int(11) NOT NULL COMMENT '1= normal, 2= true/false',
  `option_a` text NOT NULL,
  `option_b` text NOT NULL,
  `option_c` text NOT NULL,
  `option_d` text NOT NULL,
  `answer` text NOT NULL,
  `video_type` varchar(255) NOT NULL COMMENT 'server_video, external_url	',
  `video` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `note` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_wallet_transaction`
--

CREATE TABLE `tbl_wallet_transaction` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `contest_id` int(11) NOT NULL,
  `point` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_winners`
--

CREATE TABLE `tbl_winners` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `contest_id` int(11) NOT NULL,
  `rank` int(11) NOT NULL,
  `point` int(11) NOT NULL,
  `score` varchar(255) NOT NULL,
  `percentage` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_withdrawal_request`
--

CREATE TABLE `tbl_withdrawal_request` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `point` varchar(255) NOT NULL,
  `total_amount` varchar(255) NOT NULL,
  `payment_type` varchar(255) NOT NULL,
  `payment_detail` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '0- pending , 1- completed',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_admin`
--
ALTER TABLE `tbl_admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_audio_leaderboard`
--
ALTER TABLE `tbl_audio_leaderboard`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_audio_question`
--
ALTER TABLE `tbl_audio_question`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_category`
--
ALTER TABLE `tbl_category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_classification`
--
ALTER TABLE `tbl_classification`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_contest`
--
ALTER TABLE `tbl_contest`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_contest_save_report`
--
ALTER TABLE `tbl_contest_save_report`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_daily_quiz_leaderboard`
--
ALTER TABLE `tbl_daily_quiz_leaderboard`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_daily_quiz_question`
--
ALTER TABLE `tbl_daily_quiz_question`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_earnpoint_setting`
--
ALTER TABLE `tbl_earnpoint_setting`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_earn_point`
--
ALTER TABLE `tbl_earn_point`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_earn_transaction`
--
ALTER TABLE `tbl_earn_transaction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_general_setting`
--
ALTER TABLE `tbl_general_setting`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_languages`
--
ALTER TABLE `tbl_languages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_level`
--
ALTER TABLE `tbl_level`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_menu`
--
ALTER TABLE `tbl_menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_notification`
--
ALTER TABLE `tbl_notification`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_one_to_one_challenge`
--
ALTER TABLE `tbl_one_to_one_challenge`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_one_to_one_leaderboard`
--
ALTER TABLE `tbl_one_to_one_leaderboard`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_one_to_one_save_report`
--
ALTER TABLE `tbl_one_to_one_save_report`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_package`
--
ALTER TABLE `tbl_package`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_page`
--
ALTER TABLE `tbl_page`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_payment_option`
--
ALTER TABLE `tbl_payment_option`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_pratice_leaderboard`
--
ALTER TABLE `tbl_pratice_leaderboard`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_pratice_question`
--
ALTER TABLE `tbl_pratice_question`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_question`
--
ALTER TABLE `tbl_question`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_question_leaderboard`
--
ALTER TABLE `tbl_question_leaderboard`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_quiz_configuration`
--
ALTER TABLE `tbl_quiz_configuration`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_refer_earn_transaction`
--
ALTER TABLE `tbl_refer_earn_transaction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_reward_transaction`
--
ALTER TABLE `tbl_reward_transaction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_smtp_setting`
--
ALTER TABLE `tbl_smtp_setting`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_social_link`
--
ALTER TABLE `tbl_social_link`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_transaction`
--
ALTER TABLE `tbl_transaction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_true_false_leaderboard`
--
ALTER TABLE `tbl_true_false_leaderboard`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_true_false_question`
--
ALTER TABLE `tbl_true_false_question`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_user_notification_tracking`
--
ALTER TABLE `tbl_user_notification_tracking`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_video_leaderboard`
--
ALTER TABLE `tbl_video_leaderboard`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_video_question`
--
ALTER TABLE `tbl_video_question`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_wallet_transaction`
--
ALTER TABLE `tbl_wallet_transaction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_winners`
--
ALTER TABLE `tbl_winners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_withdrawal_request`
--
ALTER TABLE `tbl_withdrawal_request`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_admin`
--
ALTER TABLE `tbl_admin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_audio_leaderboard`
--
ALTER TABLE `tbl_audio_leaderboard`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_audio_question`
--
ALTER TABLE `tbl_audio_question`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_category`
--
ALTER TABLE `tbl_category`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_classification`
--
ALTER TABLE `tbl_classification`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_contest`
--
ALTER TABLE `tbl_contest`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_contest_save_report`
--
ALTER TABLE `tbl_contest_save_report`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_daily_quiz_leaderboard`
--
ALTER TABLE `tbl_daily_quiz_leaderboard`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_daily_quiz_question`
--
ALTER TABLE `tbl_daily_quiz_question`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_earnpoint_setting`
--
ALTER TABLE `tbl_earnpoint_setting`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_earn_point`
--
ALTER TABLE `tbl_earn_point`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tbl_earn_transaction`
--
ALTER TABLE `tbl_earn_transaction`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_general_setting`
--
ALTER TABLE `tbl_general_setting`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `tbl_languages`
--
ALTER TABLE `tbl_languages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_level`
--
ALTER TABLE `tbl_level`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_menu`
--
ALTER TABLE `tbl_menu`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `tbl_notification`
--
ALTER TABLE `tbl_notification`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_one_to_one_challenge`
--
ALTER TABLE `tbl_one_to_one_challenge`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_one_to_one_leaderboard`
--
ALTER TABLE `tbl_one_to_one_leaderboard`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_one_to_one_save_report`
--
ALTER TABLE `tbl_one_to_one_save_report`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_package`
--
ALTER TABLE `tbl_package`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_page`
--
ALTER TABLE `tbl_page`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_payment_option`
--
ALTER TABLE `tbl_payment_option`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_pratice_leaderboard`
--
ALTER TABLE `tbl_pratice_leaderboard`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_pratice_question`
--
ALTER TABLE `tbl_pratice_question`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_question`
--
ALTER TABLE `tbl_question`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_question_leaderboard`
--
ALTER TABLE `tbl_question_leaderboard`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_quiz_configuration`
--
ALTER TABLE `tbl_quiz_configuration`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tbl_refer_earn_transaction`
--
ALTER TABLE `tbl_refer_earn_transaction`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_reward_transaction`
--
ALTER TABLE `tbl_reward_transaction`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_smtp_setting`
--
ALTER TABLE `tbl_smtp_setting`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_social_link`
--
ALTER TABLE `tbl_social_link`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_transaction`
--
ALTER TABLE `tbl_transaction`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_true_false_leaderboard`
--
ALTER TABLE `tbl_true_false_leaderboard`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_true_false_question`
--
ALTER TABLE `tbl_true_false_question`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_user_notification_tracking`
--
ALTER TABLE `tbl_user_notification_tracking`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_video_leaderboard`
--
ALTER TABLE `tbl_video_leaderboard`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_video_question`
--
ALTER TABLE `tbl_video_question`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_wallet_transaction`
--
ALTER TABLE `tbl_wallet_transaction`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_winners`
--
ALTER TABLE `tbl_winners`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_withdrawal_request`
--
ALTER TABLE `tbl_withdrawal_request`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
