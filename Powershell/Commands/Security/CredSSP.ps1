# source : https://blogs.msdn.microsoft.com/clustering/2009/06/25/powershell-remoting-and-the-double-hop-problem/

# Run at Client Server

Enable-WSManCredSSP -Role Client –DelegateComputer [FQDN of the server]

# Run at Server

Enable-WSManCredSSP -Role Server

