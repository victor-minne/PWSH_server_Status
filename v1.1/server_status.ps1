
#count the time needed to wait for nect execution
function calc_time {
    param (
        [Parameter(Mandatory=$true)]
        $Start_time
    )
    $now = Get-Date

    $sec = ($now-$Start_time).Seconds
    $minutes = ($now-$Start_time).Minutes *60
    $exec_time = $sec + $minutes
    $result = 600 - $exec_time
    if($result -gt 0){return $result}else{ return 0}
}


$windows_servers = "SRV-HOTE03", "SRV-HOTE03", "SRV-HOTE04", "SRV-HOTE04", "SRV-ISA-DEVRECNST", "SRV-ISA-EDINAS", "SRV-ISA-NST001", "SRV-ISA-NST002", "SRV-ISA-NST003", "SRV-ISA-SQLBIREC", "SRV-ISA-SQLPROD", "SRV-PROFILS", "SRV-RDS01", "SRV-RDS02", "SRV-VMCITRIX", "SRV-VMCITRIX1", "SRV-VMDATASP", "SRV-VMDC01", "SRV-VMDC02", "SRV-VMEXCH2013", "SRV-VMFAX", "SRV-VMFILES", "SRV-VMFRONTALSP", "SRV-VMKONICA", "SRV-VMRDS01", "SRV-VMSFS", "SRV-VMVEEAM", "SRV-VMWSUS", "SRV-VMXEN00", "SRV-VMXEN01", "SRV-VMXEN02", "SRV-VMXEN03", "SRV-VMXEN04", "SRV-VMXEN05", "SVR-FICHIERS", "SVR-NAVI9"
# linux server variable need to be added so we can manage them

$Queue = New-Object System.Collections.Queue
$number_of_loop_for_mail = 3
$down_this_minute =@()
$sender_email = 'vminne@gelpass.com'
$receiver_email = 'support@gelpass.com'
$exchange_server = 'SRV-VMEXCH2013'
$priority_of_mail = 'High'


while ($true){

    $Start_time = Get-Date
    $mail_list = @()
    # server which didn't reach the mail cap but which are down :
    $server_to_log = @()
    
    Get-Date -UFormat "%m/%d/%Y %R"| Write-Output
    foreach ($server in $windows_servers) {
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
    if ($Queue.Count -gt $number_of_loop_for_mail) {
        $Queue.Dequeue()
    }

    Foreach($server in $windows_servers){

        $count =0

        foreach ($down_list in $Queue) {
            if ($down_list.contains($server)) {
                $count ++ 
            }
        }
        if ($count -ge $number_of_loop_for_mail) {
            $mail_list += $server
        }elseif ($count -le ($number_of_loop_for_mail -1)) {
            $server_to_log += $server
        }
    }

    # need to log the down servers
    # need to check that it doesn't spam mail
    if ($mail_list.Length -gt 0){

        $subject_content = "Warning : "
        $Body_content = ""
        foreach ($down_server in $mail_list) {
            $Body_content += ($down_server + ", Is down at : " + (Get-Date -UFormat "%m/%d/%Y %R")+ "`n")
            $subject_content += $down_server + ", "
        }
        $subject_content += " are Down !"

        Send-MailMessage -From $sender_email -To $receiver_email -Subject $subject_content -Body $Body_content -SmtpServer $exchange_server -Priority $priority_of_mail -DeliveryNotificationOption OnFailure
    }

    start-sleep -s (calc_time($Start_time))
}

