# PWSH_server_Status 1.1 documentation version (latest)

# Server status

version 1.1

## 1. Change Logs

- Cleaner code
- typo correction in code and doc
- easier way to modify the number of down status before sending an email.
- Send one mail per loop and not one for each server anymore.
- set the script to loop once every ten minutes. If his run time is more than 10 minutes it will restart a loop instantly after finishing the previous one.
- anticipation of future changes : 
    - log file system 
    - allowing linux server

## 2. Actions 

### 2.1 synopsis

The script aim to check if servers are up, if not it will display you that it's down. If a server is down for 30 minutes or 3 loops, it will send you an email with all down server.

### 2.2 Variables :

#### windows_servers :  

First thing is the $windows_servers variable  it allows you to enter the name of servers you want to check the status, it will tell you in the command prompt the name of the server and 'It's up!' if it is. If not it will tell you 'It's down!'. If a server is down three time in a row it will send you an email (more detail on that later). See the notes conserning IP addresses and linux server for important information on them.  

#### Queue :

Second is the variable : $Queue. It's the variable that will host the list of server that were down for the three last loop of the script main loop. It correspond of 30 minutes of inactivity if you didn't changed the default parameter conserning the wait time. $Queue is type : Queue, which means that it gets scpecial method and respect FIFO principle. (see the microsoft doc [here](https://docs.microsoft.com/en-us/dotnet/api/system.collections.queue?view=net-5.0) ).

#### number_of_loop_for_mail :

The maximum size of the Queue is determined by another variable, $number_of_loop_for_mail which set by the same time the number of loops it take to send an email and so the time. if you set it to 4, you will have a max size of 4 éléments, and for loops to wait for an email to be send and so 40 minutes of down time before email.


#### donw_this_minutes :

The variable Queue will be getting a list of $donw_this_minutes which is an array of all the servers names that are down during a loop when a new loop is started the variable is reset. It only get servers name inside.

#### Mail variables

Finaly those are not variables but you might want to change them, they are all line 25 and are parameters to send an email. You may want to change : 
- sender_email : Sender mail address
- receiver_email Receiver mail address>
- exchange_server correspond to the SmtpServer which is the name of the mail server you want to use
- priority_of_mail determine the prority of the mail its values can be : High, Normal, Low. 


## 3. Notes 

### Ip addresses :
Ip addresses aren't allowed yet, if you enter an ip it won't find the server and tell you it's down, this is the consequence of the get-service method that only take ComputerName as entry and not Ip but you can translate them before by resolving the ip with DNS, but the script in this version doesn't do it.

### Linux server :
Linux server aren't allowed yet, since they don't get the same services,method and class we can't test them the same way. so this script doesn't show if they are up. If you enter a Linux server it will always appear as down.

### Number of down before mail
If you want to change the number of down before the script send you an email you will have to change lines 20 and 24, as the line 20 fix the max size for the Queue. And line 24 to adapt for the Queue max size.

### Html for mail
html for mails aren't available in version 1.0. In the body of the mail you can only transmit plain text or join a file by adding to the command of sending an email '-Attachments' and then the path of the file you want to join.

### connection : 

Make sure that you run this on a server that got the access to run the command : 
``` 
get-service -Name Serveur -ComputerName $server
 ```

Make sure you check that the server is accessible from this server too, if you can't reach it, it will appear as down.



## 4. Comming Improvements :

- allow ip addresses 
- allow Linux servers 
- get the possibility to send html mail format and not only text.
- get log of down servers to get a historic since when it's down
- improve mail sending so it won't spam you mails if a server is down (now 6 mails an hour)
- improve readability make array for when it's up 
- adding an easier way to modify the time between start of loops
- function for mail sending
