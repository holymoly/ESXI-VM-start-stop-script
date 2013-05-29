$Server = "1.2.3.4"
$user = "YourAcount"
$pass = "YourPass"

Connect-VIServer $Server -User $user -Password $pass

$VMarray = Get-VM
$index = 1

Write-Host ""
#Print VMs to cli
$VMarray | Foreach {    
    Write-Host "$index $($_.name) found on $($_.VMHost)"
    $index += 1
}
Write-Host ""
Do { $GetMyNumber = Read-host "Write a number between 1-$($VM.length) to start a VM or 0 to abort"}
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
        Write-Host "try to start $($_.name) found on $($_.VMHost)"
        $StaringVMs = Start-VM $_ -Confirm:$false -RunAsync
    }
    $index += 1
}

Disconnect-VIServer -Confirm:$False
