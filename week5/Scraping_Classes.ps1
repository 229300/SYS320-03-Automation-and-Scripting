<#
function gatherClasses(){

$page = Invoke-WebRequest -TimeoutSec 2 http://localhost/htdocs/Courses.html

# get all tr elements
$trs=$page.ParsedHTML.body.getElementsByTagName("tr")

# array to hold results
$FullTable = @()
for($i=1; $i -lt $trs.length; $i++){

    # get every td element of current tr element
       $tds= $trs[$i].getElementsByTagName("td")

       # want to seperate start time and end time from one time field
       $Times = $tds[5].innerText.split("-")
       
           $FullTable += [pscustomobject]@{"Class Code" = $tds[0].innerText; `
                                                "Title" = $tds[1].innerText; `
                                                 "Days" = $tds[4].innerText; `
                                           "Time Start" = $Times[0]; `
                                             "Time End" = $Times[1]; `
                                           "Instructor" = $tds[6].innerText; `
                                            "Location" = $tds[9].innerText; `
                                        }
    }# for loop end
   
    return $FullTable
}

#>

<#
function daysTranslator($FullTable){

    # Go over every record in the table
    for($i=0; $i -lt $FullTable.Length; $i++){

        # Empty array to hold days for every second
        $Days = @()

        if($FullTable[$i].Days -ilike "*M*"){ $Days += "Monday" }
        if($FullTable[$i].Days -ilike "*T[TWF]*"){ $Days += "Tuesday" }
        if($FullTable[$i].Days -ilike "*W*"){ $Days += "Wednesday" }
        if($FullTable[$i].Days -ilike "*TH*"){ $Days += "Thursday" }
        if($FullTable[$i].Days -ilike "*F*"){ $Days += "Friday" }

        $FullTable[$i].Days = $Days
    }# for loop end
    return $FullTable
}

#>

# i) List all the classes of the instructor Furkan Paligu

#$FullTable | Select-Object "Class Code", Instructor, Location, Days, "Time Start", "Time End" | 
             #Where-Object { $_."Instructor" -ilike "Furkan Paligu" }
  

# ii) List all the classes of JOYC 310 on Mondays, only display Class Code and Times. Sort by Start Time


#$FullTable | Where-Object { ($_.Location -ilike "JOYC 310") -and ($_.Days -contains "Monday") } |
             #Sort-Object "Time Start" | 
             #Select-Object "Time Start", "Time End", "Class Code"


# iii) Make a list of all the instrutorsc that teach at least 1 course in one of the courses:
#SYS, NET, SEC, FOR, CSI, DAT. Sort by name and make it unique

<#

$ITSInstructors = $FullTable | Where-Object { ($_."Class Code" -ilike "SYS*") -or ` 
                                              ($_."Class Code" -ilike "NET*") -or `
                                              ($_."Class Code" -ilike "SEC*") -or `
                                              ($_."Class Code" -ilike "FOR*") -or `
                                              ($_."Class Code" -ilike "CSI*") -or `
                                              ($_."Class Code" -ilike "DAT*") } `
                                              | Select-Object "Instructor" `
                                              | Sort-Object "Instructor" -Unique
$ITSInstructors

#>

# iv) Group all the instructors by the number of classes they are teaching

$FullTable | Where { $_.Instructor -in $ITSInstructors.Instructor } `
           | Group-Object "Instructor" | Select-Object Count,Name | Sort-Object Count -Descending