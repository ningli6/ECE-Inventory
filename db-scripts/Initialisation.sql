create schema ece;

create TABLE ece.academic_role_tbl(
academicRoleID numeric(11) IDENTITY(1,1),
  academicRoleName varchar DEFAULT NULL,
  CONSTRAINT pk_academic_role_tbl PRIMARY KEY (academicRoleID)
  );


CREATE TABLE ece.user_tbl (
  userId numeric(11) NOT NULL IDENTITY(1,1),
  pid varchar(20) DEFAULT NULL,
  hokieId numeric(11) DEFAULT NULL,
  CONSTRAINT pk_user_tbl PRIMARY KEY (userId)
) ;

CREATE TABLE ece.location_tbl (
  locationID numeric(11) NOT NULL IDENTITY(1,1),
  locationName varchar(30) DEFAULT NULL,
  address varchar(30) DEFAULT NULL,
  active varchar(1) DEFAULT NULL,
  CONSTRAINT pk_location_tbl PRIMARY KEY (locationID)
) ;

drop table ece.items_tbl;
CREATE TABLE ece.items_tbl (
  itemID numeric(11) NOT NULL IDENTITY(1,1),
  itemName varchar(30) DEFAULT NULL,
  category varchar(30) DEFAULT NULL,
  purchaseDate date DEFAULT NULL,
  barcode varchar(32) DEFAULT NULL,
  comments varchar(100) DEFAULT NULL,
  currentLocationId numeric(11) DEFAULT NULL,
  currentOwnerId numeric(11) DEFAULT NULL,
  CONSTRAINT pk_items_tbl PRIMARY KEY (itemID),
  CONSTRAINT fk_items_tbl_location_tbl FOREIGN KEY (currentLocationId) REFERENCES ece.location_tbl (locationID) ,
  CONSTRAINT fk_items_tbl_user_tbl FOREIGN KEY (currentOwnerId) REFERENCES ece.user_tbl (userId)
) ;


CREATE TABLE ece. item_history_tbl (
  itemHistoryID numeric(11) NOT NULL IDENTITY(1,1),
  itemID numeric(11) DEFAULT NULL,
  locationID numeric(11) DEFAULT NULL,
  ownerID numeric(11) DEFAULT NULL,
  effectiveDate date DEFAULT NULL,
  CONSTRAINT pk_item_history_tbl PRIMARY KEY (itemHistoryID),
  CONSTRAINT fk_item_history_tbl_items_tbl FOREIGN KEY (itemID) REFERENCES ece.items_tbl (itemID) ,
  CONSTRAINT fk_item_history_tbl_user_tbl FOREIGN KEY (ownerID) REFERENCES ece.user_tbl (userId) ,
  CONSTRAINT fk_item_history_tbl_location_tbl FOREIGN KEY (locationID) REFERENCES ece.location_tbl (locationID)
) ;

CREATE TABLE ece. role_tbl (
  roleID numeric(11) NOT NULL IDENTITY(1,1),
  roleName varchar(20) DEFAULT NULL,
  CONSTRAINT pk_role_tbl PRIMARY KEY (roleID)
) ;

CREATE TABLE ece. role_access_tbl (
  roleAccessID numeric(11) NOT NULL IDENTITY(1,1),
  roleID numeric(11) DEFAULT NULL,
  access varchar(20) DEFAULT NULL,
  CONSTRAINT pk_role_access_tbl PRIMARY KEY (roleAccessID),
  CONSTRAINT fk_role_access_tbl_role_tbl FOREIGN KEY (roleID) REFERENCES ece.role_tbl (roleID)
) ;



CREATE TABLE ece. user_info_tbl (
  userInfoID numeric(11) NOT NULL IDENTITY(1,1),
  firstName varchar(30) DEFAULT NULL,
  lastName varchar(30) DEFAULT NULL,
  email varchar(30) DEFAULT NULL,
  academicRoleID numeric(11) DEFAULT NULL,
  roleID numeric(11) DEFAULT NULL,
  userID numeric(11) DEFAULT NULL,
  CONSTRAINT pk_user_info_tbl PRIMARY KEY (userInfoID),
  CONSTRAINT fk_user_info_tbl_academic_role_tbl FOREIGN KEY (academicRoleID) REFERENCES ece.academic_role_tbl (academicRoleID),
  CONSTRAINT fk_user_info_tbl_role_tbl FOREIGN KEY (roleID) REFERENCES ece.role_tbl (roleID),
  CONSTRAINT fk_user_info_tbl_user_tbl FOREIGN KEY (userID) REFERENCES ece.user_tbl (userId)
) ;