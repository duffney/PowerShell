class ScheduledTask {
    [string]$TaskName

    ScheduledTask(){}
    
    ScheduledTask([string]$TaskName) {
        $this.TaskName = $TaskName
    }  

    [void]Register(){
        Register-ScheduledTask -TaskName $this.TaskName -InputObject $this.task
    }
}

Class Action : ScheduledTask {
    [CimInstance]$ActionInstance

    Action([string]$Execute) {
        $this.ActionInstance = New-ScheduledTaskAction -Execute $Execute
    }

    Action([string]$Execute,[string]$Arguement) {
        $this.ActionInstance = New-ScheduledTaskAction -Execute $Execute -Argument $Arguement
    } 
}

Class Settings : ScheduledTask {
    [CimInstance]$SettingsInstance

    Settings() {
        $this.SettingsInstance = New-ScheduledTaskSettingsSet
    }  
}

Class Task : ScheduledTask {
    [CimInstance]$TaskInstance

    Task([CimInstance]$Actions,[CimInstance]$Settings) {
        $this.TaskInstance = New-ScheduledTask -Settings $Settings -Action $Actions
    }  
}

$Action = [Action]::new('powershell.exe','-nologon')
$Settings = [Settings]::new()
$Task = [Task]::New($Action.ActionInstance,$Settings.SettingsInstance)