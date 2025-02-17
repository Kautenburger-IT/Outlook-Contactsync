# Microsoft Graph Outlook Contact Sync

This is a Powershell script to synchronize contacts saved in Outlook from one Microsoft Exchange account to another by using a Microsoft Graph application

## Installing the Microsoft.Graph Powershell module ##

    Install-Module Microsoft.Graph

## Creating a Microsoft Graph app ##

1. Login to the Microsoft Entra Admin Center
2. Navigate to "Applications" -> "App registrations" -> "All applications"
3. Click on "New registration" and create a new Single tenant app
4. Grant the necessary Microsoft Graph permissions "Contacts.ReadWrite", "Group.ReadWrite.All" and "User.ReadAll" to the created application
5. Create a new self-signed certificate on the device that should run the application

       $mycert = New-SelfSignedCertificate -DnsName "example.com" -CertStoreLocation "cert:\CurrentUser\My" -NotAfter (Get-Date).AddYears(1) -KeySpec KeyExchange
        
       $mycert | Export-PfxCertificate -FilePath mycert.pfx -Password (Get-Credential).password
        
       $mycert | Export-Certificate -FilePath mycert.cer

6. Open "Certificates & secrets" in your reated application
7. Upload the .cer file of the created certificate
8. Note down the application ID, directory ID and the thumbprint of the uploaded certificate

See also:

- https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal
- https://learn.microsoft.com/en-us/powershell/exchange/app-only-auth-powershell-v2?view=exchange-ps

## Running the Powershell script ##

    .\contactsync.ps1 -ClientID <Client ID> -TenantID <Tenant ID> -certThumbprint <Thumbprint> -sourceUser "source@example.com" -targetUser "target@example.com"

### Notes

- The script replaces all contacts in the target folder. If there are already contacts in the target directory before running the script, these should be backed up first
- The script is created to run as a scheduled task, to synchronize contacts from one Outlook folder to another regularly. If contacts only need to be synchronized once, it is easier to just copy them manually

------------
![Logo](https://github.com/Kautenburger-IT/Kautenburger-IT/raw/main/Logo_Kautenburger-IT.png)
##  License 
https://github.com/Kautenburger-IT/Office-to-Yeastar-Converter/blob/main/LICENSE
