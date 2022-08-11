<style> 
h1{color:red; text-decoration: underline;font-weight: bolder;}
h2{color:blue; font-weight: bold;}
h3{color:green;font-weight: bold;}
</style>

# Server status

version 1.0

## 1. Actions 

### 1.1 synopsis

The script aim to check if servers are up, if not it will display you that it's down. If a server is down for 3 loop or more it will send you an email.

### 1.2 Variables :


First thing is the $servers viriable  it allows you to enter the name of servers you want to check the status, it will tell you in the command prompt the name of the server and 'It's up!' if it is. If not it will tell you 'It's down!'. If a server is down three time in a row it will send you an email (more detail on that later).

Second is the variable : $Queue. It is the variable that will host the list of server that were down for the three last loop of the script main loop, which is in the case of gelpass around 6,1 minutes each loop (roughly 18 minutes in total). It is a variable of type Queue which means that it gets scpecial method and respect FIFO principle. (see the microsoft doc [here](https://docs.microsoft.com/en-us/dotnet/api/system.collections.queue?view=net-5.0) ). 

The variable Queue will be getting a list of $donw_this_minutes which an array of all the servers that are down during a loop when a new loop is started the variable is reset. It only get servers name inside.

The status variable is used to to get the state of the Service named serveur which each windows server got running. So if this server is running the server is started. There are two cases where the service could be down even if the service is running, first when the server is unreachable if you can't reach the server, or you don't got privileges to run this command on the server, so it will appear as down.  Second is if the service state is not 'running', it could be 'restarting' for exemple. 

Finaly those are not variables but you might want to change them, they are all line 25 and are parameters to send an email. You may want to change : 
- -from \<Sender mail address>
- -TO \<Receiver mail address>
- -Subject which correspond to the object of the mail
- -Body which correspond to the text displayed 
- -SmtpServer which is the name of the mail server you want to join

## 2. Notes 

### Ip addresses :
Ip addresses aren't allowed yet, if you enter an ip it won't find the server and tell you it's down, this is the consequence of the get-service method that only take ComputerName as entry and not Ip but you can translate them before by resolving the ip with DNS, but the script in this version doesn't do it.

### Linux server :
Linux server aren't allowed yet, since they don't get the same services,method and class we can't test them the same way. so this script doesn't show if they are up. If you enter a Linux server it will always appear as down.

### Number of down before mail
If you want to change the number of down before the script send you an email you will have to change lines 20 and 24, as the line 20 fix the max size for the Queue. And line 24 to adapt for the Queue max size.

### Html for mail
html for mails aren't available in version 1.0. In the body of the mail you can only transmit plain text or join a file by adding to the command of sending an email '-Attachments' and then the path of the file you want to join.


## Comming Improvements :

- allow ip addresses 
- allow Linux servers 
- clean the line 24 so it's cleaner and easier to adapt from max size of queue
- clean the code to add variable for sending email (mail  sender/receiver and server + variable for the message)
- get the possibility to send html mail format and not only text.
- get more info to send in the email
- get log of down servers to get a historic since when it's down
- improve mail sending so it won't spam you mails if a server is down (currently 10 mails an hour)
- improve to send only one mail for all servers and not one for each
- make sure that it doesn't spanm when server coun't is low or response time fast
- improve readability make array for when it's up 
