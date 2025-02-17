param(
    [Parameter(Mandatory=$true,HelpMessage='Enter the application (client) ID of the Microsoft Graph app')][string]$clientID,
    [Parameter(Mandatory=$true,HelpMessage='Enter the directory (tenant) ID of the Microsoft Graph app')][string]$tenantID,
    [Parameter(Mandatory=$true,HelpMessage='Enter the thumbprint of the application certificate')][string]$certThumbprint,
    [Parameter(Mandatory=$true,HelpMessage='Enter the name (email address) of the source user')][string]$sourceUser,
    [Parameter(Mandatory=$true,HelpMessage='Enter the name (email address) of the target user')][string]$targetUser
)

# Connect to Microsoft Graph
Connect-MgGraph -ClientId $clientID -TenantId $tenantID -CertificateThumbprint $certThumbprint

# Get UUIDs of source and target users
$sourceId = (Get-MgUser -UserId $sourceUser).Id
$targetId = (Get-MgUser -UserId $targetUser).Id

# Get UUIDs of default contacts folder for source and target user
$sourceFolderId = (Get-MgUserContact -UserId $sourceId -Top 1).ParentFolderId
$targetFolderId = (Get-MgUserContact -UserId $targetId -Top 1).ParentFolderId

# Remove existing contacts from target folder
$targetContacts = Get-MgUserContactFolderContact -UserId $targetId -ContactFolderId $targetFolderId -All
foreach ($item in $targetContacts) {Remove-MgUserContact -UserId $targetId -ContactId $item.Id}

# Copy contacts in source folder to target folder
$sourceContacts = Get-MgUserContactFolderContact -UserId $sourceId -ContactFolderId $sourceFolderId -All
foreach ($item in $sourceContacts) {    
    New-MgUserContactFolderContact -UserId $targetId -ContactFolderId $targetFolderId -AssistantName $item.AssistantName -BusinessHomePage $item.BusinessHomePage -BusinessAddress $item.BusinessAddress -BusinessPhones $item.BusinessPhones -Categories $item.Categories -Children $item.Children -CompanyName $item.CompanyName -CreatedDateTime $item.CreatedDateTime -Department $item.Department -DisplayName $item.DisplayName -EmailAddresses $item.EmailAddresses -FileAs $item.FileAs -Generation $item.Generation -GivenName $item.GivenName -HomeAddress $item.HomeAddress -HomePhones $item.HomePhones -ImAddresses $item.ImAddresses -Initials $item.Initials -JobTitle $item.JobTitle -LastModifiedDateTime $item.LastModifiedDateTime -Manager $item.Manager -MiddleName $item.MiddleName -MobilePhone $item.MobilePhone -NickName $item.NickName -OfficeLocation $item.OfficeLocation -OtherAddress $item.OtherAddress -PersonalNotes $item.PersonalNotes -Photo $item.Photo -Profession $item.Profession -SpouseName $item.SpouseName -Surname $item.Surname -Title $item.Title -YomiCompanyName $item.YomiCompanyName -YomiGivenName $item.YomiGivenName -YomiSurname $item.YomiSurname -AdditionalProperties $item.AdditionalProperties
}

# Disconnect from Microsoft Graph
Disconnect-Graph
