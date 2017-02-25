$inf = @"
[Version] 
Signature="`$Windows NT`$"

[NewRequest]
Subject = "CN=Pullv2, OU='IT, O=Globomantics, L=Omaha, S=NE, C=US"
KeySpec = 1
KeyLength = 2048
Exportable = TRUE
FriendlyName = PSDSCPullServerCert2
MachineKeySet = TRUE
SMIME = False
PrivateKeyArchive = FALSE
UserProtected = FALSE
UseExistingKeySet = FALSE
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ProviderType = 12
RequestType = PKCS10
KeyUsage = 0xa0
"@

$infFile = 'C:\temp\certrq.inf'
$requestFile = 'C:\temp\request.req'
$CertFileOut = 'c:\temp\certfile.cer'

$inf | Set-Content -Path "C:\temp\certrq.inf"

& certreq.exe -new "$infFile" "$requestFile"

& certreq.exe -submit -config Pullv2.globomantics.com\globomantics-PULLV2-CA -attrib "CertificateTemplate:WebServer" "$requestFile" "$CertFileOut"

& certreq.exe -accept "$CertFileOut"