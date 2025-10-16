. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - Get At Risk Users`n"
$Prompt += "10 - Exit`n"



$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 10){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }


    # Create a user
   elseif($choice -eq 3){ 

        $name = Read-Host -Prompt "Please enter the username for the new user"
        $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"

        # TODO: Create a function called checkUser in Users that: 
        #              - Checks if user a exists. 
        #              - If user exists, returns true, else returns false
        # TODO: Check the given username with your new function.
        #              - If false is returned, continue with the rest of the function
        #              - If true is returned, do not continue and inform the user
        #
        # TODO: Create a function called checkPassword in String-Helper that:
        #              - Checks if the given string is at least 6 characters
        #              - Checks if the given string contains at least 1 special character, 1 number, and 1 letter
        #              - If the given string does not satisfy conditions, returns false
        #              - If the given string satisfy the conditions, returns true
        # TODO: Check the given password with your new function. 
        #              - If false is returned, do not continue and inform the user
        #              - If true is returned, continue with the rest of the function

        if (checkUser $name) { Write-Host "User '$name' already exists."; continue }   
        if (-not (checkPassword $password)) { Write-Host "Password does not meet requirements."; continue }  

        createAUser $name $password

        Write-Host "User: $name is created." | Out-String
    }

        


    # Remove a user
    elseif($choice -eq 4){

        $name = Read-Host -Prompt "Please enter the username for the user to be removed"

        # TODO: Check the given username with the checkUser function.
        if (-not (checkUser $name)) { Write-Host "User '$name' Does not exist."; continue }  

        removeAUser $name

        Write-Host "User: $name Removed." | Out-String
    }


    # Enable a user
    elseif($choice -eq 5){


        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"

        $chkUser = checkuser $name

        # TODO: Check the given username with the checkUser function.
        if($chkUser -eq $true){
            enableAUser $name
            Write-Host "User: $name Enabled." | Out-String
        }
        else { Write-Host "User Does Not Exist." | Out-String }

    }


    # Disable a user
    elseif($choice -eq 6){

        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"

        $chkUser = checkuser $name

        # TODO: Check the given username with the checkUser function.
        if($chkUser -eq $true){
            disableAUser $name
            Write-Host "User: $name Disabled." | Out-String
        }
        else{ Write-Host "User Does Not Exist" | Out-String }
    }

    # get login logs
    elseif($choice -eq 7){

        $name = Read-Host -Prompt "Please enter the username for the user logs"

        $chkUser = checkuser $name
        # TODO: Check the given username with the checkUser function.
        if($chkUser -eq $true){

           $days = Read-Host "How many days of logs would you like to view"
           $userLogins = getLogInAndOffs $days
           Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String) }
           else { Write-Host "User Does Not Exist" }
    }


    # get failed log in
    elseif($choice -eq 8){

        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"

        $chkUser = checkuser $name
        
        if (chkUser -eq $true) {
            $days = Read-Host "How many days of logs would you like to view"
            $userLogins = getFailedLogins $days
            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String) }
            else { Write-Host "User Does Not Exist" }



    # TODO: Create another choice "List at Risk Users" that
    #              - Lists all the users with more than 10 failed logins in the last <User Given> days.  
    #                (You might need to create some failed logins to test)
    #              - Do not forget to update prompt and option numbers
    
    # TODO: If user enters anything other than listed choices, e.g. a number that is not in the menu   
    #       or a character that should not be accepted. Give a proper message to the user and prompt again.
    

}



elseif($choice -eq 9) {
        
        $days = Read-Host "How many days of logs would you like to view"
        at_risk_users -days $days }
    else { Write-Host "$choice is invalid. Try again with a number 1-10." }
}
