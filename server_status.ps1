$servers = "SERVER NAME"
$Queue = New-Object System.Collections.Queue
while ($true){
    $down_this_minute =@()
    Get-Date -UFormat "%m/%d/%Y %R"| Write-Output
    foreach ($server in $servers) {
        $status = (get-service -Name Serveur -ComputerName $server).Status
        if ($status -eq "Running") {
            $server + ": Its Up!"
        } else {
            $server + ": Its Down!"
            $down_this_minute += $server
        }
    }
    "________________________"


    $Queue.Enqueue($down_this_minute)
    if ($Queue.Count -gt 3) {
        $Queue.Dequeue()
    }

    Foreach($server in $servers){
        if ($Queue[0].contains($server) -and $Queue[1].Contains($server) -and $Queue[2].Contains($server)){
            Send-MailMessage -From 'vminne@gelpass.com' -To 'support@gelpass.com' -Subject ($server + 'is down !') -Body ($server + "is down for more than 3 minutes.") -SmtpServer 'SRV-VMEXCH2013' -Priority High -DeliveryNotificationOption OnFailure
         }
    }
}
