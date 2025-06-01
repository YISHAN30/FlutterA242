-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 01, 2025 at 11:47 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `os_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `checkin_worker`
--

CREATE TABLE `checkin_worker` (
  `id` int(11) NOT NULL,
  `worker_id` int(11) NOT NULL,
  `worker_name` varchar(100) NOT NULL,
  `checkin_date` date NOT NULL,
  `checkin_time` time NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `checkin_worker`
--

INSERT INTO `checkin_worker` (`id`, `worker_id`, `worker_name`, `checkin_date`, `checkin_time`, `latitude`, `longitude`) VALUES
(1, 1, 'Ali', '2025-05-30', '12:30:00', 37.4219983, -122.084),
(2, 1, 'Ali', '2025-05-30', '12:41:00', 37.4219983, -122.084),
(3, 1, 'Ali', '2025-05-30', '12:45:00', 37.4219983, -122.084),
(4, 1, 'Ali', '2025-05-30', '12:58:00', 37.4219983, -122.084),
(5, 1, 'Ali', '2025-05-30', '12:59:00', 37.4219983, -122.084),
(6, 1, 'Ali', '2025-05-30', '01:00:00', 37.4219983, -122.084),
(7, 1, 'Ali', '2025-05-30', '01:08:00', 37.4219983, -122.084),
(8, 1, 'Ali', '2025-05-30', '01:10:00', 37.4219983, -122.084),
(9, 3, 'Abu', '2025-05-30', '01:16:00', 37.4219983, -122.084),
(10, 3, 'Abu', '2025-05-30', '01:17:00', 37.4219983, -122.084),
(11, 3, 'Abu', '2025-06-01', '09:04:00', 37.4219983, -122.084),
(12, 3, 'Abu', '2025-06-01', '09:22:00', 37.4219983, -122.084);

-- --------------------------------------------------------

--
-- Table structure for table `checkout_worker`
--

CREATE TABLE `checkout_worker` (
  `id` int(11) NOT NULL,
  `worker_id` int(11) NOT NULL,
  `worker_name` varchar(100) NOT NULL,
  `checkout_date` date NOT NULL,
  `checkout_time` time NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `checkout_worker`
--

INSERT INTO `checkout_worker` (`id`, `worker_id`, `worker_name`, `checkout_date`, `checkout_time`, `latitude`, `longitude`) VALUES
(1, 1, 'Ali', '2025-05-30', '12:51:14', 37.4219983, -122.084),
(2, 1, 'Ali', '2025-05-30', '12:58:00', 37.4219983, -122.084),
(3, 1, 'Ali', '2025-05-30', '13:00:00', 37.4219983, -122.084),
(4, 1, 'Ali', '2025-05-30', '13:01:00', 37.4219983, -122.084),
(5, 1, 'Ali', '2025-05-30', '13:10:00', 37.4219983, -122.084),
(6, 3, 'Abu', '2025-05-30', '13:17:00', 37.4219983, -122.084),
(7, 3, 'Abu', '2025-05-30', '13:19:00', 37.4219983, -122.084),
(8, 3, 'Abu', '2025-06-01', '09:43:00', 37.4219983, -122.084);

-- --------------------------------------------------------

--
-- Table structure for table `os_worker`
--

CREATE TABLE `os_worker` (
  `worker_id` int(11) NOT NULL,
  `worker_name` varchar(100) NOT NULL,
  `worker_email` varchar(100) NOT NULL,
  `worker_password` varchar(255) NOT NULL,
  `worker_phone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `os_worker`
--

INSERT INTO `os_worker` (`worker_id`, `worker_name`, `worker_email`, `worker_password`, `worker_phone`) VALUES
(1, 'Ali', 'ali123@gmail.com', '$2y$10$6mNLETygM3/0mBSciNLSx.Mpn0jyyk6GXu6pDL4eE6iYfhYFDGe7K', '0123659874'),
(2, 'Yi Shan', 'yishan123@gmail.com', '$2y$10$8WkmET/f7S/YqW1zlVfKcu0tA1pB6AyQOirkb.AP/3K7bFSD7E4Qm', '0123654789'),
(3, 'Abu', 'abu123@gmail.com', '$2y$10$a/3ezPnmH0P5s0lW.LSR4OxVyX3.RwESWZMZ2Aj.XsTB0CUA4lP8e', '01123456789');

-- --------------------------------------------------------

--
-- Table structure for table `tasksubmission_worker`
--

CREATE TABLE `tasksubmission_worker` (
  `id` int(11) NOT NULL,
  `worker_id` int(11) NOT NULL,
  `worker_name` varchar(100) NOT NULL,
  `submission_date` date NOT NULL,
  `tasks_completed` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tasksubmission_worker`
--

INSERT INTO `tasksubmission_worker` (`id`, `worker_id`, `worker_name`, `submission_date`, `tasks_completed`) VALUES
(1, 1, 'Ali', '2025-05-30', 'Clean bathroom thoroughly, Vacuum and mop floors, Dust all surfaces, Change bed linens, Empty trash bins, Clean kitchen countertops, Wipe windows and mirrors, Sanitize door handles and switches, Restock toiletries and supplies, Check appliances for cleanliness'),
(2, 1, 'Ali', '2025-05-30', 'Clean bathroom thoroughly'),
(3, 1, 'Ali', '2025-05-30', 'Wipe windows and mirrors'),
(4, 1, 'Ali', '2025-05-30', 'Clean bathroom thoroughly, Vacuum and mop floors'),
(5, 1, 'Ali', '2025-05-30', 'Empty trash bins'),
(6, 3, 'Abu', '2025-05-30', 'Clean bathroom thoroughly, Sanitize door handles and switches, Check appliances for cleanliness'),
(7, 3, 'Abu', '2025-05-30', 'Clean kitchen countertops, Wipe windows and mirrors'),
(8, 3, 'Abu', '2025-05-30', 'Sanitize door handles and switches'),
(9, 3, 'Abu', '2025-06-01', 'Change bed linens');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `checkin_worker`
--
ALTER TABLE `checkin_worker`
  ADD PRIMARY KEY (`id`),
  ADD KEY `worker_id` (`worker_id`);

--
-- Indexes for table `checkout_worker`
--
ALTER TABLE `checkout_worker`
  ADD PRIMARY KEY (`id`),
  ADD KEY `worker_id` (`worker_id`);

--
-- Indexes for table `os_worker`
--
ALTER TABLE `os_worker`
  ADD PRIMARY KEY (`worker_id`),
  ADD UNIQUE KEY `worker_email` (`worker_email`);

--
-- Indexes for table `tasksubmission_worker`
--
ALTER TABLE `tasksubmission_worker`
  ADD PRIMARY KEY (`id`),
  ADD KEY `worker_id` (`worker_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `checkin_worker`
--
ALTER TABLE `checkin_worker`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `checkout_worker`
--
ALTER TABLE `checkout_worker`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `os_worker`
--
ALTER TABLE `os_worker`
  MODIFY `worker_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tasksubmission_worker`
--
ALTER TABLE `tasksubmission_worker`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `checkin_worker`
--
ALTER TABLE `checkin_worker`
  ADD CONSTRAINT `checkin_worker_ibfk_1` FOREIGN KEY (`worker_id`) REFERENCES `os_worker` (`worker_id`) ON DELETE CASCADE;

--
-- Constraints for table `checkout_worker`
--
ALTER TABLE `checkout_worker`
  ADD CONSTRAINT `checkout_worker_ibfk_1` FOREIGN KEY (`worker_id`) REFERENCES `os_worker` (`worker_id`) ON DELETE CASCADE;

--
-- Constraints for table `tasksubmission_worker`
--
ALTER TABLE `tasksubmission_worker`
  ADD CONSTRAINT `tasksubmission_worker_ibfk_1` FOREIGN KEY (`worker_id`) REFERENCES `os_worker` (`worker_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
