#######################################################################################################################
#Drop Tables
drop table eceinventory.test;
drop table eceinventory.`user_info_tbl`;
drop table eceinventory.`role_access_tbl`;
drop table eceinventory.`item_history_tbl`;
drop table eceinventory.`items_tbl`;
drop table eceinventory.`role_tbl`;
drop table eceinventory.`user_tbl`;
drop table eceinventory.`academic_role_tbl`;
drop table eceinventory.`location_tbl`;
drop table eceinventory.`item_orgination_tbl`;
drop table eceinventory.`item_ownership_tbl`;
drop table eceinventory.`item_manufacturer_tbl`;
drop table eceinventory.`item_model_tbl`;
drop table eceinventory.`asset_type_tbl`;
#######################################################################################################################
#CREATE
create table eceinventory.test(
col_Owner varchar(255),
col_Orgn_Code varchar(255),
col_Orgn_Title varchar(255),
col_Room varchar(255),
col_Bldg varchar(255),
col_Sort_Room varchar(255),
col_Ptag varchar(255),
col_Manufacturer varchar(255),
col_Model varchar(255),
col_Serial_Number varchar(255),
col_Description varchar(255),
col_Custodian varchar(255),
col_PO varchar(255),
col_Acq_Date varchar(255),
col_Amt varchar(255),
col_Ownership varchar(255),
col_Schev_Year varchar(255),
col_Tag_Type varchar(255),
col_Asset_Type varchar(255),
col_Atyp_Title varchar(255),
col_Condition_State varchar(255),
col_Last_Inv_Date varchar(255),
col_Designation varchar(255),
col_extra_1 varchar(255));
#######################################################################################################################
CREATE TABLE eceinventory.`item_orgination_tbl` (
  `itemOrignCode` int(11) NOT NULL,
  `itemOrignTitle` varchar(50) DEFAULT NULL,
  CONSTRAINT pk_item_orgination_tbl PRIMARY KEY (`itemOrignCode`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`item_ownership_tbl` (
  `itemOwnerID` int(11) NOT NULL AUTO_INCREMENT,
  `itemOwnerCode` varchar(50) DEFAULT NULL,
  `itemOwnerDescription` varchar(100) DEFAULT NULL,
  CONSTRAINT pk_item_ownership_tbl PRIMARY KEY (`itemOwnerID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`item_manufacturer_tbl` (
  `itemManufacturerID` int(11) NOT NULL AUTO_INCREMENT,
  `itemManufacturerName` varchar(50) DEFAULT NULL,
  CONSTRAINT item_manufacturer_tbl PRIMARY KEY (`itemManufacturerID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`item_model_tbl` (
  `itemModelID` int(11) NOT NULL AUTO_INCREMENT,
  `itemModelName` varchar(100) DEFAULT NULL,
  CONSTRAINT item_model_tbl PRIMARY KEY (`itemModelID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`academic_role_tbl` (
  `academicRoleID` int(11) NOT NULL AUTO_INCREMENT,
  `academicRoleName` varchar(20) DEFAULT NULL,
  CONSTRAINT pk_academic_role_tbl PRIMARY KEY (`academicRoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`user_tbl` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `pid` varchar(20) DEFAULT NULL,
  `hokieId` int(11) DEFAULT NULL,
  `nameInBanner` varchar (255) DEFAULT NULL,
  CONSTRAINT pk_user_tbl PRIMARY KEY (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`location_tbl` (
  `locationID` int(11) NOT NULL AUTO_INCREMENT,
  `locationName` varchar(100) DEFAULT NULL,
  `room` varchar(50) DEFAULT NULL,
   `building` varchar(50) DEFAULT NULL,
    `address` varchar(255) DEFAULT NULL,
  `active` varchar(1) DEFAULT 'Y',
  CONSTRAINT pk_location_tbl PRIMARY KEY (`locationID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`asset_type_tbl` (
  `assetTypeId` int(11) NOT NULL AUTO_INCREMENT,
  `assetTypeCode` varchar(5) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  CONSTRAINT asset_type_tbl PRIMARY KEY (`assetTypeId`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`items_tbl` (
  `itemID` int(11) NOT NULL AUTO_INCREMENT,
  `pTag` int(30) DEFAULT NULL,
  `serialNumber` varchar(50) DEFAULT NULL,
   `description` varchar(500) DEFAULT NULL,
   `purchaseOrder` varchar(50) DEFAULT NULL,
  `purchaseDate` varchar(50) DEFAULT NULL,
  `purchaseAmount` varchar(15),
  `comments` varchar(100) DEFAULT NULL,
  `ownershipID` int(11),
  `currentLocationId` int(11) DEFAULT NULL,
  `currentCustodianId` int(11) DEFAULT NULL,
  `schevYear` varchar(5) default null,
  `tagType` varchar(20) default null,
  `assetTypeId` int(11) default null,
  `condition` varchar(20) default null,
  `lastInventoryDate` varchar(15) default null,
  `designation` varchar(25) default null,
  `activeStatus` varchar(1) default 'Y',
  CONSTRAINT pk_items_tbl PRIMARY KEY (`itemID`),
  KEY `currentLocationId` (`currentLocationId`),
  KEY `currentCustodianId` (`currentCustodianId`),
  KEY `ownershipID` (`ownershipID`),
  KEY `assetTypeId` (`assetTypeId`),
  CONSTRAINT `fk_items_tbl_location_tbl` FOREIGN KEY (`currentLocationId`) REFERENCES eceinventory.`location_tbl` (`locationID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_items_tbl_user_tbl` FOREIGN KEY (`currentCustodianId`) REFERENCES eceinventory.`user_tbl` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_items_tbl_item_ownership_tbl` FOREIGN KEY (`ownershipID`) REFERENCES eceinventory.`item_ownership_tbl` (`itemOwnerId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_items_tbl_asset_type_tbl` FOREIGN KEY (`assetTypeId`) REFERENCES eceinventory.`asset_type_tbl` (`assetTypeId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`item_history_tbl` (
  `itemHistoryID` int(11) NOT NULL AUTO_INCREMENT,
  `itemID` int(11) DEFAULT NULL,
  `locationID` int(11) DEFAULT NULL,
  `ownerID` int(11) DEFAULT NULL,
  `effectiveDate` date DEFAULT NULL,
  CONSTRAINT pk_item_history_tbl PRIMARY KEY (`itemHistoryID`),
  KEY `itemID` (`itemID`),
  KEY `ownerID` (`ownerID`),
  KEY `locationID` (`locationID`),
  CONSTRAINT `fk_item_history_tbl_items_tbl` FOREIGN KEY (`itemID`) REFERENCES eceinventory.`items_tbl` (`itemID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_item_history_tbl_user_tbl` FOREIGN KEY (`ownerID`) REFERENCES eceinventory.`user_tbl` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_item_history_tbl_location_tbl` FOREIGN KEY (`locationID`) REFERENCES eceinventory.`location_tbl` (`locationID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`role_tbl` (
  `roleID` int(11) NOT NULL AUTO_INCREMENT,
  `roleName` varchar(20) DEFAULT NULL,
  CONSTRAINT pk_role_tbl PRIMARY KEY (`roleID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`role_access_tbl` (
  `roleAccessID` int(11) NOT NULL AUTO_INCREMENT,
  `roleID` int(11) DEFAULT NULL,
  `access` varchar(20) DEFAULT NULL,
  CONSTRAINT pk_role_access_tbl PRIMARY KEY (`roleAccessID`),
  KEY `roleID` (`roleID`),
  CONSTRAINT `fk_role_access_tbl_role_tbl` FOREIGN KEY (`roleID`) REFERENCES eceinventory.`role_tbl` (`roleID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
#######################################################################################################################
CREATE TABLE eceinventory.`user_info_tbl` (
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
  CONSTRAINT `fk_user_info_tbl_academic_role_tbl` FOREIGN KEY (`academicRoleID`) REFERENCES eceinventory.`academic_role_tbl` (`academicRoleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_info_tbl_role_tbl` FOREIGN KEY (`roleID`) REFERENCES eceinventory.`role_tbl` (`roleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_info_tbl_user_tbl` FOREIGN KEY (`userID`) REFERENCES eceinventory.`user_tbl` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
####################################################################################################
#truncate
truncate table eceinventory.test;
####################################################################################################
#insert
load data local infile 'D:\\ECEInventory\\SQL\\Load\\test2.csv' into table eceinventory.test fields terminated by '\t' lines terminated by '\n' ignore 1 lines;
#######################################################################################################################
insert into eceinventory.`item_orgination_tbl` (itemOrignCode, itemOrignTitle)  (select distinct col_orgn_code, col_orgn_title from eceinventory.test);
#######################################################################################################################
insert into eceinventory.`item_ownership_tbl` (itemOwnerCode, itemOwnerDescription)  (select distinct col_Owner, col_Ownership from eceinventory.test);
#######################################################################################################################
insert into eceinventory.`item_manufacturer_tbl` (itemManufacturerName)  (select distinct col_Manufacturer from eceinventory.test);
#######################################################################################################################
insert into eceinventory.`item_model_tbl` (itemModelName)  (select distinct col_Model from eceinventory.test);
#######################################################################################################################
Insert into eceinventory.`academic_role_tbl` values (1,'Admin'),(2, 'Faculty'), (3, 'Student'), (4, 'Viewer');
#######################################################################################################################
insert into eceinventory.`user_tbl` (nameInBanner)  (select distinct col_Custodian from eceinventory.test);
#######################################################################################################################
insert into eceinventory.`location_tbl` (locationName, room, building)  (select distinct col_Sort_Room, col_Room, col_Bldg
 from eceinventory.test);
####################################################################################################################### 
insert into eceinventory.`asset_type_tbl` (assetTypeCode,title )  (select distinct col_Asset_Type, col_Atyp_Title
 from eceinventory.test);
 #######################################################################################################################
insert into eceinventory.`items_tbl` (pTag, serialNumber, description, purchaseOrder, purchaseDate, purchaseAmount,
 ownershipID,	currentLocationId , currentCustodianId , schevYear,  tagType,  assetTypeId,  `condition` ,
  lastInventoryDate,  designation ,  activeStatus  ) 
(select distinct t.col_Ptag, t.col_Serial_Number, t.col_Description, t.col_PO, t.col_Acq_Date, t.col_Amt, 
o.itemOwnerID, l.locationID, u.userId, t.col_Schev_Year, t.col_Tag_Type, a.assetTypeId, t.col_Condition_State,
t.col_Last_Inv_Date, t.col_Designation, 'Y'
from eceinventory.test t left join
eceinventory.`user_tbl`u
on t.col_Custodian = u.nameInBanner
left join
eceinventory.`item_ownership_tbl` o
on( t.col_Ownership = o.itemOwnerDescription
and t.col_Owner = o.itemOwnerCode)
left join
eceinventory.`location_tbl` l
on t.col_Sort_Room = l.locationName
left join 
eceinventory.`asset_type_tbl` a
on t.col_Asset_Type = a.assetTypeCode);
#######################################################################################################################
insert into eceinventory.`user_info_tbl` (firstName, lastName, userID)  (select distinct substr(t.col_Custodian, locate(',' , col_Custodian)+2) 
,substr(t.col_Custodian, 1, locate(',', t.col_Custodian)-1)
, u.userId
from eceinventory.test t left join
eceinventory.`user_tbl`u
on t.col_Custodian = u.nameInBanner );
#######################################################################################################################
#select
select * from eceinventory.test;
select * from  eceinventory.`item_orgination_tbl`;
select * from  eceinventory.`item_ownership_tbl`;
select * from  eceinventory.`item_model_tbl`;
select * from  eceinventory.`item_manufacturer_tbl`;
select * from eceinventory.`academic_role_tbl`;
select * from eceinventory.`user_tbl`;
select * from eceinventory.`location_tbl`;
select * from eceinventory.asset_type_tbl;
select * from eceinventory.`items_tbl`;
select * from eceinventory.`user_info_tbl`;
#######################################################################################################################