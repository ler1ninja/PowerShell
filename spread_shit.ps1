$port = 443
$net = read-host “where we are going ? 10.94.73.0”
$range = 16..35
foreach ($r in $range)
{
   $ip = “{0}.{1}” -F $net,$r
    if(Test-Connection -BufferSize 32 -Count 1 -Quiet -ComputerName $ip){
 	   $socket = new-object System.Net.Sockets.TcpClient($ip, $port)
 	   if($socket.Connected){
    	    “$ip listening to port $port”
            New-Item -Path "\\$ip\c$" -ItemType file -Name nicePics.jpg -Value "We've got it"
    	     $socket.Close()}
         }
 }
