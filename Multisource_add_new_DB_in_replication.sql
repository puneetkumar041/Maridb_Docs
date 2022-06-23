#####+++++++++++ HOW to add new Server and DB in existing Multisource replication ++++++++++++++####

 `MASTER Side Changes`
++++++++++++++++++++++
Step 1:
=======

create database katni;
use katni;
CREATE TABLE `tbl_EmployeeDetails` (
  `EmpID` int(11) DEFAULT NULL,
  `EmpName` varchar(50) DEFAULT NULL,
  `EmailAddress` varchar(50) DEFAULT NULL,
  KEY `pk_tbl_EmployeeDetails_EmpID` (`EmpID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;


----------------------------------------------
Step 2:
=======
#Take backup with binary log position

mysqldump -u root -p --master-data=2 --databases katni> /backup/allbckdb.sql 


----------------------------------------------
Step 3:
=======
#Note binary log position from where slave will start sync

head -23 allbckdb.sql
Ex : #(CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000005', MASTER_LOG_POS=934;)


------------------------------------------------------------------

`SLAVE Side Changes`
++++++++++++++++++++

Step 4:
=======
#Stop replication for that channel


STOP SLAVE 'Master116';
-----------------------------------------------------------
Step 5:
=======
#Copy and Restore data

mysql -u root -p < /backup/allbckdb.sql 

------------------------------------------------------------
Step 6:
=======
#Start the sync for that channel

CHANGE MASTER 'Master116' to MASTER_HOST='192.168.56.116', MASTER_PORT=3306, MASTER_USER='replica1', MASTER_PASSWORD='pass@123', MASTER_LOG_FILE='mysql-bin.000005', MASTER_LOG_POS=934;

---------------------------------
Step 7:
=======
START SLAVE 'Master116';
-----------------------------

Check the replication status
SHOW SLAVE 'Master116' STATUS\G;
