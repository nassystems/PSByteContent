function Assert {
    [CmdletBinding(DefaultParameterSetName = 'Exception')]
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [bool] $InputObject,
        [Parameter(Position = 1, ParameterSetName = 'Message')]
        [string] $Message,
        [Parameter(Position = 1, ParameterSetName = 'Exception')]
        [System.Exception] $Exception)
    if(-not $InputObject) {
        switch($PSCmdlet.ParameterSetName) {
            'Message' {Write-Error -ErrorAction Stop -Message $Message}
            default   {
                if($null -eq $Exception) {
                    Write-Error -ErrorAction Stop -Message 'Assertion failed.'
                } else {
                    Write-Error -ErrorAction Stop -Exception $Exception
                }
            }
        }
    }
}
