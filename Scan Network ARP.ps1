#fichier de logs
$logfile='d:\arp.log'
$logs=@()
$cmd=@()
#Récupération du contenu du fichier de logs existant
If(Test-Path -Path $logfile)
{
    $logs+=Import-CSV -Path $logfile
}
$date=Get-Date
#Balayage par ping du réseau 10.94.73.0/24
For($i=1;$i -lt 255;$i++)
{
    $ping=ping 10.94.73.$i -n 1 -w 5
    #Récupération de la commande arp -a toutes les 60 secondes
    If($date.AddSeconds(60) -lt (Get-Date))
    {
        $cmd+=arp -a
        $date=Get-Date
    } 
}
$cmd+=arp -a
#Elimination des doublons du fait de l'exécution régulière de arp -a
$cmd=$cmd|Sort -Unique
#Récupération des adresses ip et mac
ForEach($row in $cmd)
{
    If($row -match '^ +([0-9\.]+) +([0-9a-f\-]+) +[a-z]+ +$')
    {
        $ip=$Matches[1]
        $mac=$Matches[2]
        $logs+=[PSCustomObject]@{date=$date;ip=$ip;mac=$mac}
    }
}
#Sauvegarde des données de la table arp dans le fichier de logs
$logs| Export-CSV -NoTypeInformation -Path $logfile
#Facultatif : affichage des résultats si vous exécutez le script en mode interactif
$logs|Out-GridView -Title 'Log Arp Scan'
$logs=$null
