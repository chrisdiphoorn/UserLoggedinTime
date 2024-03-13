# Written By C.Diphoorn 2024
# A Powershell Script to return the time in Hours, Minutes, Days,  the Current User has been Logged In for
# Arguments: [-Hour] [-Hours] [-Day] [-Days] [-Mins] 
# The default Output is Hours if no Argument has been passed. (Arguments also dont need the Minus at the Beginning of them)
#
# EG: TimeLoggedin.ps1 -Days  , TimeLoggedin.ps1 mins
# Output: 0.642501215027778
#
# NB: Outputs nothing (Blank) if the current user or their datetime details cant be evaluated.
#

if($args) {
	$arg = $args[0].ToString().ToLower()
}

$currentuser = [Environment]::UserName
$users=(Get-WmiObject win32_networkloginprofile | ? {$_.lastlogon -ne $null} | % {[PSCustomObject]@{User=$_.caption; LastLogon=[Management.ManagementDateTimeConverter]::ToDateTime($_.lastlogon)}})
$datediff = $null

if($users) {
	$user = $users | where-object {$_.User -eq $currentuser }
	if($user) {
		 $lastlogon = (Get-Date -Date $user.LastLogon)
		 $currentDate = (Get-Date)
		 $datediff = $currentDate - $lastlogon
	}
	if($datediff -ne $null) {
		$option = $arg -replace '-',''
		switch($option) {
			day {
				$datediff.TotalDays
				break
			}
			days {
				$datediff.TotalDays
				break
			}
			hours {
				$datediff.TotalHours
				break
			}
			hour {
				$datediff.TotalHours
				break
			}
			mins {
				$datediff.TotalMinutes
				break
			}
			min {
				$datediff.TotalMinutes
				break
			}
			default {
				$datediff.TotalHours
			}
		}
	}
}
