SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gta5_gamemode_essential`
-- PLEASE IMPORT THIS INTO YOUR DATABASE (SET IN SETTINGS.LUA)

-- --------------------------------------------------------

--
-- Table structure for table `loadouts`
--

CREATE TABLE `loadouts` (
  `identifier` varchar(256) NOT NULL COMMENT 'The player''s identifier',
  `loadout_name` varchar(256) NOT NULL COMMENT 'The loadout they currently have',
  `hair` int(11) NOT NULL,
  `haircolour` int(11) NOT NULL,
  `torso` int(11) NOT NULL,
  `torsotexture` int(11) NOT NULL,
  `torsoextra` int(11) NOT NULL,
  `torsoextratexture` int(11) NOT NULL,
  `pants` int(11) NOT NULL,
  `pantscolour` int(11) NOT NULL,
  `shoes` int(11) NOT NULL,
  `shoescolour` int(11) NOT NULL,
  `bodyaccessory` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
