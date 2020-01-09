function Get-SelfSignedCertParamObject {
    [CmdletBinding(
        PositionalBinding = $false
    )]

    Param(
    )
    
    end {
        
        @{
            Country          = 'AU'
            State            = 'Some-State'
            Location         = ''
            Organization     = 'Internet Widgits Pty Ltd'
            OrganizationUnit = ''
            CommonName       = 'localhost'
            Email            = ''
        }
    }
}
