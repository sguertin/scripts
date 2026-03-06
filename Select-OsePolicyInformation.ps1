function Select-OsePolicyInformation {
    param(
        [Parameter(Mandatory, Position = 1, ValueFromPipeline = $true)][System.IO.FileInfo]$Path
    )
    process {

        [xml]$xml = Get-Content -Path $Path -Raw;
        $namedInsured = "//os:CDXFEntity[contains(os:EntityRole/os:value, 'First Named Insured')]"
        $addressId = Select-DxfValue -Xml $xml -XPath "$namedInsured/os:PreferredMailingAddressEntityRef";
        $transactionPolicy = "//os:CDXFPolicyTransactionPolicy"
        $address = "//os:CDXFDeliveryMethod[@os_id = '$addressId']";        
        return @{
            NamedInsured   =((Select-DxfValue -Xml $xml -XPath "$namedInsured/os:EntityLegalName") ?? 
                             (Select-DxfValue -Xml $xml -XPath "$namedInsured/os:EntityBusinessName") ?? "");
            Address1       = (Select-DxfValue -Xml $xml -XPath "$address/os:AddressLine1") ?? "";
            Address2       = (Select-DxfValue -Xml $xml -XPath "$address/os:AddressLine2") ?? "";
            City           = (Select-DxfValue -Xml $xml -XPath "$address/os:AddressCity") ?? "";
            State          = (Select-DxfValue -Xml $xml -XPath "$address/os:AddressStateProvince/os:code") ?? "";
            Zip            = (Select-DxfValue -Xml $xml -XPath "$address/os:AddressPostalCode") ?? "";
            PolicyNumber   =((Select-DxfValue -Xml $xml -XPath "$transactionPolicy/os:PolicyNumber") ?? 
                             (Select-DxfValue -Xml $xml -XPath "$transactionPolicy/os:PolicyLegacyID") ?? "");
            PolicyState    = (Select-DxfValue -Xml $xml -XPath "$transactionPolicy/os:CDXFPolicyCustomer/os:CDXFCustomerJurisdiction/os:CDXFStateCode/os:code") ?? "";
            PolicyType     = (Select-DxfValue -Xml $xml -XPath "$transactionPolicy/os:PolicyProduct/os:value") ?? "";
            Program        = (Select-DxfValue -Xml $xml -XPath "$transactionPolicy/os:ProgramType/os:value") ?? "";
            EffectiveDate  = Convert-OseDateTime (
                Select-DxfValue -Xml $xml -XPath "$transactionPolicy/os:PolicyEffectiveDate"
            );
            ExpirationDate = Convert-OseDateTime (
                Select-DxfValue -Xml $xml -XPath "$transactionPolicy/os:PolicyExpirationDate"
            );
        };        
    }
}