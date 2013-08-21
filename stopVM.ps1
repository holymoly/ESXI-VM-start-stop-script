$Server = "192.168.1.1"
$user = "user"
$pass = "pass"

Connect-VIServer $Server -User $user -Password $pass

$VMarray = Get-VM | where { ($_.PowerState -eq "PoweredOn") } 
$index = 1

Write-Host ""
#Print VMs to cli
$VMarray | Foreach {    
    Write-Host "$index $($_.name) found on $($_.VMHost)"
    $index += 1
}
Write-Host ""
Do { $GetMyNumber = Read-host "Write a number between 1-$($VMarray.length) to stop a VM or 0 to abort"}
until (($GetMyNumber -le $VMarray.length) -and ($GetMyNumber -ge 0))

$index = 1
$VMarray | Foreach {   
    #Abort if input was 0 
    if ($GetMyNumber -eq 0){
        Write-Host "aborted"
        Disconnect-VIServer -Confirm:$False
        Exit
    }

    #check which VM was chosen
    if ($GetMyNumber -eq $index){
        Write-Host "try to stop $($_.name) found on $($_.VMHost)"
        $StaringVMs = Stop-VM $_ -Confirm:$false -RunAsync
    }
    $index += 1
}

Disconnect-VIServer -Confirm:$False
