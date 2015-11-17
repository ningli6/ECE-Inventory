CREATE TABLE `academic_role_tbl` (
  `academicRoleID` int(11) NOT NULL AUTO_INCREMENT,
  `academicRoleName` varchar(20) DEFAULT NULL,
  CONSTRAINT pk_academic_role_tbl PRIMARY KEY (`academicRoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `user_tbl` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `pid` varchar(20) DEFAULT NULL,
  `hokieId` int(11) DEFAULT NULL,
  CONSTRAINT pk_user_tbl PRIMARY KEY (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `location_tbl` (
  `locationID` int(11) NOT NULL AUTO_INCREMENT,
  `locationName` varchar(30) DEFAULT NULL,
  `address` varchar(30) DEFAULT NULL,
  `active` varchar(1) DEFAULT NULL,
  CONSTRAINT pk_location_tbl PRIMARY KEY (`locationID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `items_tbl` (
  `itemID` int(11) NOT NULL AUTO_INCREMENT,
  `itemName` varchar(30) DEFAULT NULL,
  `category` varchar(30) DEFAULT NULL,
  `purchaseDate` date DEFAULT NULL,
  `barcode` varchar(32) DEFAULT NULL,
  `comments` varchar(100) DEFAULT NULL,
  `currentLocationId` int(11) DEFAULT NULL,
  `currentOwnerId` int(11) DEFAULT NULL,
  CONSTRAINT pk_items_tbl PRIMARY KEY (`itemID`),
  KEY `currentLocationId` (`currentLocationId`),
  KEY `currentOwnerId` (`currentOwnerId`),
  CONSTRAINT `fk_items_tbl_location_tbl` FOREIGN KEY (`currentLocationId`) REFERENCES `location_tbl` (`locationID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_items_tbl_user_tbl` FOREIGN KEY (`currentOwnerId`) REFERENCES `user_tbl` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


CREATE TABLE `item_history_tbl` (
  `itemHistoryID` int(11) NOT NULL AUTO_INCREMENT,
  `itemID` int(11) DEFAULT NULL,
  `locationID` int(11) DEFAULT NULL,
  `ownerID` int(11) DEFAULT NULL,
  `effectiveDate` date DEFAULT NULL,
  CONSTRAINT pk_item_history_tbl PRIMARY KEY (`itemHistoryID`),
  KEY `itemID` (`itemID`),
  KEY `ownerID` (`ownerID`),
  KEY `locationID` (`locationID`),
  CONSTRAINT `fk_item_history_tbl_items_tbl` FOREIGN KEY (`itemID`) REFERENCES `items_tbl` (`itemID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_item_history_tbl_user_tbl` FOREIGN KEY (`ownerID`) REFERENCES `user_tbl` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_item_history_tbl_location_tbl` FOREIGN KEY (`locationID`) REFERENCES `location_tbl` (`locationID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `role_tbl` (
  `roleID` int(11) NOT NULL AUTO_INCREMENT,
  `roleName` varchar(20) DEFAULT NULL,
  CONSTRAINT pk_role_tbl PRIMARY KEY (`roleID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `role_access_tbl` (
  `roleAccessID` int(11) NOT NULL AUTO_INCREMENT,
  `roleID` int(11) DEFAULT NULL,
  `access` varchar(20) DEFAULT NULL,
  CONSTRAINT pk_role_access_tbl PRIMARY KEY (`roleAccessID`),
  KEY `roleID` (`roleID`),
  CONSTRAINT `fk_role_access_tbl_role_tbl` FOREIGN KEY (`roleID`) REFERENCES `role_tbl` (`roleID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;



CREATE TABLE `user_info_tbl` (
  `userInfoID` int(11) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(30) DEFAULT NULL,
  `lastName` varchar(30) DEFAULT NULL,
  `email` varchar(30) DEFAULT NULL,
  `academicRoleID` int(11) DEFAULT NULL,
  `roleID` int(11) DEFAULT NULL,
  `userID` int(11) DEFAULT NULL,
  CONSTRAINT pk_user_info_tbl PRIMARY KEY (`userInfoID`),
  KEY `academicRoleID` (`academicRoleID`),
  KEY `roleID` (`roleID`),
  KEY `userID` (`userID`),
  CONSTRAINT `fk_user_info_tbl_academic_role_tbl` FOREIGN KEY (`academicRoleID`) REFERENCES `academic_role_tbl` (`academicRoleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_info_tbl_role_tbl` FOREIGN KEY (`roleID`) REFERENCES `role_tbl` (`roleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_info_tbl_user_tbl` FOREIGN KEY (`userID`) REFERENCES `user_tbl` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

##CREATE TABLE `user_table` (
##  `id` int(11) DEFAULT NULL,
##  `name` varchar(30) DEFAULT NULL
##) ENGINE=InnoDB DEFAULT CHARSET=latin1;

##CREATE TABLE `item_table` (
 ## `id` int(11) DEFAULT NULL,
 ## `name` varchar(30) DEFAULT NULL
##) ENGINE=InnoDB DEFAULT CHARSET=latin1;






