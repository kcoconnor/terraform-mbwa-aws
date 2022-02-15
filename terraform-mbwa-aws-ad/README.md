#Microsoft AD Password Policies

## AWSProtectedPSO

|Policy | Setting|  
|:---   |:---    |  
|Enforce password history | 24 passwords remembered|  
|Maximum password age|	42 days| 
|Minimum password age|	1 day| 
|Minimum password length|	7 characters| 
|Password must meet complexity requirements|Enabled| 
|Store passwords using reversible encryption|Disabled| 

###Command to set:
N/A
     
###Assigned To:
N/A


##DelegatedAdminPSO-10

|Policy | Setting| 
|:---   |:---    |
|Enforce password history | 24 passwords remembered|
|Maximum password age|	60 days|
|Minimum password age|	0 day|
|Minimum password length|	20 characters|
|Password must meet complexity requirements|Enabled|
|Store passwords using reversible encryption|Disabled|
|Unsuccessful Login Attempts | 10 attempts|
|Lockout Duration| 5 | 

###Command to set:
     pwgen -cnrs 20 1

###Assigned To:
AD\Admin


##ServiceAccountsPSO-20

|Policy | Setting| 
|:---   |:---    |
|Maximum password age|	365 days|
|Minimum password age|	0 day|
|Minimum password length|	20 characters|
|Password must meet complexity requirements|Enabled|
|Store passwords using reversible encryption|Disabled|
|Unsuccessful Login Attempts | 10 attempts|
|Lockout Duration| 0 - Admin Reset Required| 

###Command to set:
     pwgen -cnrs 20 1

###Assigned To:
AD\ServiceAccounts


##UserPSO-50

|Policy | Setting| 
|:---   |:---    |
|Enforce password history | 8 passwords remembered|
|Maximum password age|	90 days|
|Minimum password age|	1 day|
|Minimum password length|	8 characters|
|Password must meet complexity requirements|Enabled|
|Store passwords using reversible encryption|Disabled|
|Unsuccessful Login Attempts | 10 attempts|
|Lockout Duration| 0 - Admin Reset Required| 

###Command to set:
     pwgen 8 1

###Assigned To:
AD\AppUsers






## References
[Microsoft AD Password Policies](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_password_policies.html)

[How to configure stronger password policies](https://aws.amazon.com/blogs/security/how-to-configure-even-stronger-password-policies-to-help-meet-your-security-standards-by-using-aws-directory-service-for-microsoft-active-directory/)

[pwgen](https://sourceforge.net/projects/pwgen/)


## Commands

    # Rename CustomerPSO-01 to DelegatedAdminPSO-10    
    Rename-ADObject -Identity:"CN=CustomerPSO-01,CN=Password Settings Container,CN=System,DC=ad,DC=dev,DC=mbwa,DC=co" -NewName:"DelegatedAdminPSO-10"
    
    # Set Password Policy for Delegated Admins, Minimum Length = 20, Maximum Password Age 60 days
    Set-ADFineGrainedPasswordPolicy -ComplexityEnabled:$true -Identity:"CN=DelegatedAdminPSO-10,CN=Password Settings Container,CN=System,DC=ad,DC=dev,DC=mbwa,DC=co" -LockoutDuration:"00:30:00" -LockoutObservationWindow:"00:30:00" -LockoutThreshold:"0" -MinPasswordAge:"1.00:00:00" -MinPasswordLength:"20"
    
    # Add the AD\Admin ID to the Delegated Admin Password Policy
    Add-ADFineGrainedPasswordPolicySubject -Identity:"CN=DelegatedAdminPSO-10,CN=Password Settings Container,CN=System,DC=ad,DC=dev,DC=mbwa,DC=co"  -Subjects:"CN=Admin,OU=Users,OU=ad,DC=ad,DC=dev,DC=mbwa,DC=co"
    
    
        
    # Rename CustomerPSO-02 to ServiceAccountsPSO-20
    Rename-ADObject -Identity:"CN=CustomerPSO-02,CN=Password Settings Container,CN=System,DC=ad,DC=dev,DC=mbwa,DC=co" -NewName:"ServiceAccountsPSO-20"

    # Set Password Policy for ServiceAccounts, Minimum Length = 20, Maximum Password Age 365 days, with 10 failed logins in 30 minutes causing a lockout until unlocked by Admin    
    Set-ADFineGrainedPasswordPolicy -ComplexityEnabled:$true -Identity:"CN=ServiceAccountsPSO-20,CN=Password Settings Container,CN=System,DC=ad,DC=dev,DC=mbwa,DC=co" -LockoutDuration:"-10675199.02:48:05.4775808" -LockoutObservationWindow:"00:30:00" -LockoutThreshold:"10" -MinPasswordAge:"1.00:00:00" -MinPasswordLength:"20"
    
    # Create ServiceAccounts Group
    New-ADGroup -GroupCategory:"Security" -GroupScope:"Global" -Name:"ServiceAccounts" -Path:"OU=Users,OU=ad,DC=ad,DC=dev,DC=mbwa,DC=co" -SamAccountName:"ServiceAccounts"
    
    # Add the AD\ServiceAccounts Group to the ServiceAccounts Password Policy
    Add-ADFineGrainedPasswordPolicySubject -Identity:"CN= ServiceAccountsPSO-20,CN=Password Settings Container,CN=System,DC=ad,DC=dev,DC=mbwa,DC=co" -Subjects:"CN= ServiceAccounts,OU=Users,OU=ad,DC=ad,DC=dev,DC=mbwa,DC=co"
    


    # Rename CustomerPSO-05 to AppUsersPSO-50
    Rename-ADObject -Identity:"CN=CustomerPSO-05,CN=Password Settings Container,CN=System,DC=ad,DC=dev,DC=mbwa,DC=co" -NewName:"AppUsersPSO-50"

    # Set Password Policy for AppUsers, Minimum Length = 8, Maximum Password Age 90 days, with 10 failed logins in 30 minutes causing a lockout until unlocked by Admin    
    Set-ADFineGrainedPasswordPolicy -ComplexityEnabled:$true -Identity:"CN=AppUsersPSO-50,CN=Password Settings Container,CN=System,DC=ad,DC=dev,DC=mbwa,DC=co" -LockoutDuration:"-10675199.02:48:05.4775808" -LockoutObservationWindow:"00:30:00" -LockoutThreshold:"10" -MaxPasswordAge:"90.00:00:00" -MinPasswordAge:"1.00:00:00" -MinPasswordLength:"8"
    
    # Create AppUsers Group
    New-ADGroup -GroupCategory:"Security" -GroupScope:"Global" -Name:"AppUsers" -Path:"OU=Users,OU=ad,DC=ad,DC=dev,DC=mbwa,DC=co" -SamAccountName:"AppUsers"
    
    # Add the AD\AppUsers Group to the AppUsers Password Policy
    Add-ADFineGrainedPasswordPolicySubject -Identity:"CN=AppUsersPSO-50,CN=Password Settings Container,CN=System,DC=ad,DC=dev,DC=mbwa,DC=co" -Subjects:"CN= AppUsers,OU=Users,OU=ad,DC=ad,DC=dev,DC=mbwa,DC=co"
 
    
