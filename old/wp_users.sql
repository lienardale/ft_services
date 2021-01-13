-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : mysql-service:3306
-- Généré le : mar. 01 sep. 2020 à 09:58
-- Version du serveur :  10.4.13-MariaDB
-- Version de PHP : 7.3.21
-- USED ONLY FOR DEBUG PURPOSES

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `wordpress`
--

-- --------------------------------------------------------

--
-- Structure de la table `wp_users`
--

-- INSERT INTO TABLE `wp_users` (
--   `ID` bigint(20) UNSIGNED NOT NULL,
--   `user_login` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
--   `user_pass` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
--   `user_nicename` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
--   `user_email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
--   `user_url` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
--   `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
--   `user_activation_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
--   `user_status` int(11) NOT NULL DEFAULT 0,
--   `display_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `wp_users`
--

INSERT INTO `wp_users` (`ID`, `user_login`, `user_pass`, `user_nicename`, `user_email`, `user_url`, `user_registered`, `user_activation_key`, `user_status`, `display_name`) VALUES
(2, 'me', '$P$BsO3MbNkAmQ01yQ2W7gOFjxRFFEhsH/', 'me', 'me@me.fr', 'http://192.168.99.124:5050', '2020-09-01 09:53:19', '', 0, 'me'),
(3, 'admin', '$P$BVHuhrODonBjeLUqG/H1pQRwKFfYlo1', 'admin', 'admin@admin.admin', 'http://admin.fr', '2020-09-01 09:54:06', '1598954046:$P$B4y9BlJ0pIA0G/a2TowPG9WE/Pv6KP/', 0, 'admin admin'),
(4, 'hanni', '$P$BTCZpp1lFyBzOBRIyoX1G8NyUgvUyu1', 'hanni', 'hanni@hanni.fr', '', '2020-09-01 09:57:01', '1598954221:$P$B80dMAn/3cFb8UVlVvJhLZ5SQcBlP71', 0, 'hanni');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `wp_users`
--
-- ALTER TABLE `wp_users`
--   ADD PRIMARY KEY (`ID`),
--   ADD KEY `user_login_key` (`user_login`),
--   ADD KEY `user_nicename` (`user_nicename`),
--   ADD KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `wp_users`
--
ALTER TABLE `wp_users`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
