# ---------------------------------------------------
# Version: 1.0
# Author: Joshua Duffney
# Date: 07/13/2014
# Description: Using PowerShell to Unblock files that are downloaded from the internet.
# Comments: Call the function Unblcok with the path to the folder containing blocked files in "" after it, see line 15.
# ---------------------------------------------------

Function Unblock ($path) { 

gci "$path" -Recurse | Unblock-File -WhatIf

}

Unblock "C:\Downloads\PSAppDeployToolkit_v3.1.4"
