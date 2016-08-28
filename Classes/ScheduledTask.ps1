class ScheduledTask {
    [string]$TaskName
    [CimInstance]$Action
    [CimInstance]$Settings
    [CimInstance]$Task

    ScheduledTask([string]$TaskName) {
        $this.TaskName = $TaskName
    }

    [void]SetAction([string]$Execute){
        $this.Action = New-ScheduledTaskAction -Execute $Execute
    }

    [void]SetSettings(){
        $this.Settings = New-ScheduledTaskSettingsSet
    }

    [void]SetTask(){
        $this.Task = New-ScheduledTask -Settings $this.Settings -Action $this.Action
    }

    [void]Register(){
        Register-ScheduledTask -TaskName $this.TaskName -InputObject $this.task
    }
}

$NewTask = [ScheduledTask]::New('T6')
$NewTask.SetAction('Taskmgr.exe')
$NewTask.SetSettings()
$NewTask.SetTask()

$NewTask