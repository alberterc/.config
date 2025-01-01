# Powershell Profile
Built because I sometimes confuse Unix commands with its alternative for Powershell in Windows.

## How to use?
- Check the Powershell profile directory by running ```$PROFILE``` in the Powershell terminal.
- Create the directory if it doesn't exist and create a backup (ex: by renaming/moving the file into a different directory) if another profile is already present in the directory. 
```Example path: C:\Users\Username\Documents\PowerShell\Microsoft.PowerShell_profile.ps1```
- Download and move the Microsoft.PowerShell_profile.ps1 file into the ```$PROFILE``` directory.
- Run ```profile -help``` to display the profile help function.

<details>
	<summary>
		<h2><code>[Click to show]</code> Notes</h2>
	</summary>
	
### Things to consider
- Commands in Unix output everything as text. On the other hand, commands in Powershell output everything as object.
- Piping command outputs need to consider commands output. ```ex: Object.text | function (Powershell) vs Text | function (Unix)```

### Todo
- Test support for Powershell 5.
- Make installation easier.
- Create automatic update when profile is active and powershell is opened.
</details>
