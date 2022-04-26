FUNCTION Connect-Exchange {
    <#
.SYNOPSIS
Checks for an open Exchange session and connects to it, or makes a new connection if needed.

.DESCRIPTION
This script checks for an open connection to Exchange, and imports that session to make Exchange commands available.  If there is no connection, it attempts to connect the Exchange 2016 environment.


.NOTES
┌──────────────────────────────────────┐
│ ORIGIN STORY                         │
├──────────────────────────────────────┤
│   DATE        : 31JUL2020            │
│   AUTHOR      : CGuertin             │
│   DESCRIPTION : Initial Draft        │
└──────────────────────────────────────┘

.EXAMPLE
Connect-Exchange
"This will connect to Exchange, and prompt for which user to use to connect if needed."
#>

    if (Get-PSSession | Where-Object { $_.ConfigurationName -eq "Microsoft.Exchange" }) {
        $exsess = Get-PSSession | Where-Object { $_.ConfigurationName -eq "Microsoft.Exchange" }
        if ($exsess.State -eq "Broken") {
            Remove-PSSession -Session $exsess
            $cred = Get-Credential
            New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://us-mia-ex16-01.tuv.group/powershell" -Authentication kerberos -Credential $Cred
            Import-PSSession (Get-PSSession | Where-Object { $_.ConfigurationName -eq "Microsoft.Exchange" })[0] -AllowClobber -ErrorAction SilentlyContinue
        } Else {
            Import-PSSession -Session $exsess[0] -AllowClobber -ErrorAction SilentlyContinue
        } 
    } else {
        $cred = Get-Credential
        New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://us-mia-ex16-01.tuv.group/powershell" -Authentication kerberos -Credential $Cred
        Import-PSSession (Get-PSSession | Where-Object { $_.ConfigurationName -eq "Microsoft.Exchange" })[0] -AllowClobber -ErrorAction SilentlyContinue
    }
}



FUNCTION New-SharedMailbox {

    <#
.SYNOPSIS
 Creates a new shared mailbox for AMER region
 
.DESCRIPTION
 This function will create a shared mailbox for the AMER region.  It will create the (disabled) AD user and activate them for mail.  It will set the proper SMTP addresses required as well as a number of optional fields if specified.

.NOTES
┌──────────────────────────────────────┐
│ ORIGIN STORY                         │
├──────────────────────────────────────┤
│   DATE        : 03AUG2020            │
│   AUTHOR      : CGuertin             │
│   DESCRIPTION : Initial Draft        │
└──────────────────────────────────────┘
 
.PARAMETER User  (REQUIRED)
Username of the shared mailbox.  This will be the SAMACCOUNTNAME of the Active Directory user (ex: US-MAIL-SMBX )
 
.PARAMETER DisplayName
Specifies a specific preferred Display Name for the account.  This will appear as the "Name" in emails, rather than the username above.

.PARAMETER Region (REQUIRED, defaults to AMER)
Give the region that the resource is being made for.  AMER or two-letter country abbreviations are valid

.PARAMETER Owner (REQUIRED)
Username of the owner of the box.  This user will get FullAccess to the mailbox, as well as be the company code and cost center that should be billed.

.PARAMETER Access
Comma delimited list of users that should be granted FullAccess to the resource on its creation (Owner gets this be default).

.PARAMETER SendAs
Comma delimited list of users that should be granted SendOnBehalfOf rights to this mailbox (none by default)

.PARAMETER Billing
CompanyCode,CostCenter specification.  Must be formatted with comma like: 0040,22096   This will override billing the "OWNER" with whatever cost center is specified here.

.PARAMETER Email
Specify external email (SMTP) address(es) for this account, rather than just the default USER@TUV.GROUP address.  The first one provided will be the PrimarySMTPAddress

.PARAMETER Type (REQUIRED, defaults to Shared)
Specifies the type of shared mailbox being created.  SHARED, ROOM, and CAL are acceptable values

.PARAMETER Description
Specify a free-text description for this mailbox.

.PARAMETER Credential
Specify an alternate (ADM) set of credentials to run commands as

.EXAMPLE
New-SharedMailbox BR-CONF1-ROOM -DisplayName "Front Conference Room - Sao Paolo" -region BR -type ROOM -owner tboss -cred sadm-ituser
"This will create a shared mailbox for room reservations, running as the SADM-ITUSER user account."

.EXAMPLE
New-SharedMailbox US-AHAM-SMBX -DisplayName "Team Hamilton" -region US -Owner gwashington -access ahamilton,aburr -SendAs ahamilton -billing 5243,1207 -email InTheRoom@us.tuv.com
"This will create the shared mailbox US-AHAM-SMBX with the displayname Team Hamilton.  It will make GWASHINGTON the owner, grant full access to AHAMILTON and ABURR, grant AHAMILTON the ability to SendOnBehalfOf", set billing to TRIS cost center 1207, with the external email of InTheRoom@us.tuv.com."

.EXAMPLE
New-SharedMailbox US-CABINET-CAL DisplayName "Washington Cabinet" -region US -0wner gwashington -access ahamilton,tjefferson -type cal
"This will create the shared calendar US-CABINET-CAL with GWASHINGTON as the owner and give owner calendar access to AHAMILTON and TJEFFERSON.  Billing info will match GWASHINGTON"
#>

    #region Parameters
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript( {
                $userblock = @"            
$_ does not meet the standard for name formatting.  Please reformat in standard REGION-NAME-TYPE.
Acceptable REGION prefixes are:
US
MX
CA
AR
BR
CL
PE
CO
BO
Acceptable TYPE suffixes are:
SMBX, CAL, and ROOM.
"@

                $OKregion = 'US', 'MX', 'CA', 'AR', 'BR', 'CL', 'PE', 'CO', 'BO'
                $OKtype = 'SMBX', 'CAL', 'ROOM'
                $NameChunks = $_.Split("-")
                if ($okregion -contains $NameChunks[0] -and $oktype -contains $NameChunks[-1]) {
                    $true
                } else {
                    throw $userblock
                }
            })]
        [string]$User,
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$DisplayName,
        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateSet('US', 'MX', 'CA', 'AR', 'BR', 'CL', 'PE', 'CO', 'BO')]
        [string]$Region,
        [Parameter(Mandatory = $true, Position = 3)]
        [ValidateScript( { Get-ADUser $_ })]
        [string]$Owner,
        [Parameter(Mandatory = $false, Position = 4)]
        [ValidateScript( { Get-ADUser $_ })]
        [array]$Access,
        [Parameter(Mandatory = $false, Position = 5)]
        [ValidateScript( { Get-ADUser $_ })]
        [array]$SendAs,
        [Parameter(Mandatory = $false, Position = 6)]
        [ValidateScript( {
                if ($_ -match '^\d{4}-') {
                    $true
                } else {
                    throw "$_ is invalid Company Code and cost center format. Please use format 0040-22096"
                }
            })]
        [string]$Billing,
        [Parameter(Mandatory = $false, Position = 7)]
        [ValidateScript( {
                if (Get-Mailbox $_ ) {
                    throw "$_ is already in use for an email address."
                } else {
                    $true
                }
            })]
        [array]$Email,
        [Parameter(Mandatory = $false, Position = 8)]
        [ValidateSet('SMBX', 'CAL', 'ROOM')]
        [string]$Type,
        [Parameter(Mandatory = $false, Position = 9)]
        [string]$Description,
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )
    #endregion

    Connect-Exchange

    #region Variable creation
    ###Note that RESSOURCES is still spelled wrong in the active directory folder structure.
    if ($type -eq "SMBX") {
        $OUType = "SharedMailboxes"
    } elseif ($type -eq "CAL") {
        $OUType = "CAL"
    } elseif ($type -eq "ROOM") {
        $OUType = "Ressources"
    }
    $OU = "tuv.group/EXCHANGE/AMER/" + $REGION + "/General/" + $OUType
    $CompCode, $CostCenter = $billing.split('-')
    $UPN = $user + "@tuv.group"
    $UserCAL = $user + ":\calendar"
    $Database = Get-MailboxDatabase | Where-Object { $_.Name -like "AMER-EX16-DB*" }

    #endregion

    #region Mailbox Creation here!
    Switch ($type) {
        SMBX {
            $ExtEmail = $Email[0]
            New-Mailbox $user -Alias $user -Database $Database -Shared -userprincipalname $UPN -organizationalunit $OU
            foreach ($a in $access) {
                Add-MailboxFolderPermission $user -user $a -AccessRights 'FullAccess'
            }
            Add-MailboxFolderPermission $user -user $owner -AccessRights 'FullAccess'
            Set-Mailbox $User -EmailAddressPolicyEnabled $False
            Set-Mailbox $user -emailaddresses @{Add = $email } -ErrorAction SilentlyContinue
            Set-Mailbox $user -PrimarySMTPAddress $ExtEmail -ErrorAction SilentlyContinue
            Set-Mailbox -Identity $User -GrantSendOnBehalfTo @{add = $SendAs }
            $TypeOut = "Shared mailbox with external address of $ExtEmail. Owner username is $Owner. Full Access also given to: $Access.  SendOnBehalf of granted to: $SendAs."
        }
        CAL {
            $TypeOut = "Shared Calender created for Owner $Owner.  Owner access also granted to: $Access."
            New-Mailbox $User -Alias $User -Database $Database -Shared -userprincipalname $UPN -organizationalunit $OU
            foreach ($a in $access) {
                Add-MailboxFolderPermission $UserCAL -user $a -AccessRights 'Owner'
            }
            Add-MailboxFolderPermission $UserCAL -user $owner -AccessRights 'Owner'
            Set-Mailbox $User -EmailAddressPolicyEnabled $False
        }
        Room {
            $TypeOut = "Room reservation created successfully.  Please add to any appropriate Room Lists as well."
            New-Mailbox $User -Alias $User -Database $Database -Room -userprincipalname $UPN -organizationalunit $OU
            Set-Mailbox $User -EmailAddressPolicyEnabled $False
        }
    }

    Set-Mailbox -Identity $User -CustomAttribute1 $CostCenter
    Set-Mailbox -Identity $User -CustomAttribute2 "040"
    Set-Mailbox -Identity $User -CustomAttribute3 $CompCode
    Set-Mailbox -Identity $User -CustomAttribute14 $Owner

    Write-Host "New Shared Mailbox created for $user ( $DisplayName )"
    Write-Host $TypeOut
    Write-Host "Resource will be billed to owner unless specified differently here: CC $CostCenter in Company Code $CompCode."
    #endregion

} #close FUNCTION New-SharedMailbox
