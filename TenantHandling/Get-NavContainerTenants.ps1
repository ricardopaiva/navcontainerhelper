﻿<# 
 .Synopsis
  Retrieve all Tenants in a multitenant NAV/BC Container
 .Description
  Get information about all tenants in the Container
 .Parameter containerName
  Name of the container from which you want to get the tenant information
 .Parameter Tenant
  Specifies the ID of the specific tenant that you want to get information about, such as Tenant1.
 .Parameter forceRefresh
  Specifies to update a tenant's state and data version based, in part, on the data version of the tenant database that contains the tenant. 
 .Parameter force
  Forces the command to run without asking for user confirmation.
 .Example
  Get-NavContainerTenants -containerName test
#>
function Get-NavContainerTenants {
    [CmdletBinding(DefaultParameterSetName = 'UseContainerName')]
    Param (
        [Parameter(Mandatory = $false)]
        [string] $containerName = "navserver",

        [Parameter(Mandatory = $true, ParameterSetName = 'ForceRefreshTenantState')]
        [switch] $ForceRefresh,

        [Parameter(Mandatory = $false, ParameterSetName = 'ForceRefreshTenantState')]
        [ValidateNotNullorEmpty()]
        [string] $Tenant = 'default',

        [switch] $Force
    )
    $Params = @{ "Force" = $Force }
    If ($ForceRefresh) {
        $Params += @{
            "ForceRefresh" = $ForceRefresh
            "Tenant"       = $Tenant
        }
    }
    Invoke-ScriptInNavContainer -containerName $containerName -ScriptBlock {
        Param( [PsCustomObject] $Params)
        Get-NavTenant -ServerInstance $ServerInstance @Params
    } -argumentList $Params
}
Set-Alias -Name Get-BCContainerTenants -Value Get-NavContainerTenants
Export-ModuleMember -Function Get-NavContainerTenants -Alias Get-BCContainerTenants
