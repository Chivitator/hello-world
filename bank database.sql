
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `bank`
--

CREATE DATABASE `bank`;

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `AccountType` varchar(30) NOT NULL,
  `CurrentBalance` double UNSIGNED NOT NULL,
  `AccountStatus` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `notificationrules`
--

CREATE TABLE `notificationrules` (
  `id` int(11) NOT NULL,
  `Description` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `TransactionType` varchar(30) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `TransactionType` varchar(30) NOT NULL,
  `ProcessingDate` datetime NOT NULL DEFAULT current_timestamp(),
  `Balance` double NOT NULL,
  `Amount` double NOT NULL,
  `Description` varchar(255) NOT NULL,
  `Account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `transactions`
--
DELIMITER $$
CREATE TRIGGER `NewTransaction` AFTER INSERT ON `transactions` FOR EACH ROW INSERT into notifications VALUES(null, NEW.id, 'A new'+TransactionType+'Transaction has been initiated in your account', NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `CreatedAt` timestamp(6) NOT NULL DEFAULT current_timestamp(6),
  `lastLogin` timestamp NOT NULL DEFAULT current_timestamp(),
  `loggedIn` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `newUser` AFTER UPDATE ON `users` FOR EACH ROW INSERT into notifications VALUES(null, NEW.id, "New User Login", NOW())
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accountOwnership` (`owner`);

--
-- Indexes for table `notificationrules`
--
ALTER TABLE `notificationrules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `LinkedTransactionAcct` (`Account`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notificationrules`
--
ALTER TABLE `notificationrules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `accountOwnership` FOREIGN KEY (`owner`) REFERENCES `users` (`id`);

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `LinkedTransactionAcct` FOREIGN KEY (`Account`) REFERENCES `accounts` (`id`);
COMMIT;
