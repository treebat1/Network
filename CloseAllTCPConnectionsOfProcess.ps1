function Close-AppConnection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name
    )

    process
    {
        $processes = Get-Process -Name $Name

        foreach($process in $processes)
        {
            $connections = Get-NetTCPConnection -OwningProcess $process.Id

            foreach($connection in $connections)
            {
                Write-Verbose "Disposing TCP connection port '$($connection.LocalPort)' for '$($process.Name)'"
                $connection.Dispose()
            }
        }
    }
}

# example use -- close TCP connections for OneDrive
Close-AppConnection OneDrive -Verbose