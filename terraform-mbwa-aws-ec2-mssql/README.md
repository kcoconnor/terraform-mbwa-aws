1. launch ec2
2. connect via ssm/rdp
3. install visual studio 2019 community edition
https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=community&rel=16&utm_medium=microsoft&utm_source=docs.microsoft.com&utm_campaign=download+from+relnotes&utm_content=vs2019ga+button



4. install microsoft dotnet run pack for 4.6.2
5. download solution
6. update reference
7. https://www.linkedin.com/pulse/ssrs-2017-anonymous-authentication-problem-solved-frans-van-der-geer/


      New-ADUser -Name "ssrsportaluser" -Enabled $true

      aws ds reset-user-password --directory-id d-90675ca8a0 --user-name ssrsportaluser --new-password jmLqgCnzf8QnBQRBpT


Users
Groups
Computers
Policy
  Password
  Lockout

ad.dev.mbwa.co

|OU |Purpose|  
|:---|:----|  
|Users|User accounts for non-administrative personnel.|  
|Service Accounts|Some services that require access to network resources are run under user accounts. This OU is created to separate and distinguish service user accounts from the human user accounts contained in the Users OU. Also, by placing the different types of user accounts in separate OUs, you can manage them according to their different administrative requirements.|  
|Computers|Computer accounts other than Domain Controllers.|  
|Groups |Groups of all types, except administrative groups, which are managed separately.|  
|Admins|User and group accounts for administrative personnel, to allow them to be managed separately from regular users. Auditing should be enabled for this OU so you can track changes to administrative users and groups.|  


ad.stg.mbwa.co
ad.prd.mbwa.co

Predefined database roles
You may need to create your own, but you have access to several predefined database roles:

db_owner: Members have full access.
db_accessadmin: Members can manage Windows groups and SQL Server logins.
db_datareader: Members can read all data.
db_datawriter: Members can add, delete, or modify data in the tables.
db_ddladmin: Members can run dynamic-link library (DLL) statements.
db_securityadmin: Members can modify role membership and manage permissions.
db_bckupoperator: Members can back up the database.
db_denydatareader: Members can’t view data within the database.
db_denydatawriter: Members can’t change or delete data in tables or views.

Fixed roles

The fixed server roles are applied serverwide, and there are several predefined server roles:

SysAdmin: Any member can perform any action on the server.
ServerAdmin: Any member can set configuration options on the server.
SetupAdmin: Any member can manage linked servers and SQL Server startup options and tasks.
Security Admin: Any member can manage server security.
ProcessAdmin: Any member can kill processes running on SQL Server.
DbCreator: Any member can create, alter, drop, and restore databases.
DiskAdmin: Any member can manage SQL Server disk files.
BulkAdmin: Any member can run the bulk insert command.


Administrators
FileShareAdministrators
DatabaseAdministrators
ServerAdministrators
DomainNameAdministrators

ssrsportaluser
hPDzKMDdZdgZZWQJS3

ssrsportalunknown
5pksfVpZxVbb5269tg
