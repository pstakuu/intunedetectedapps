####################
#DELEGATED TOKEN CODE#
$AppId = 'fcf9f64f-adf4-46ef-8da2-asdfasdfasdfa' #get from app registration page
$tenantID = 'b72d93ab-3d71-4f0d-aa18-fdafasdfa' #get from AzureAD properties page
$redirectURI = "http%3A%2F%2Flocalhost" #get from app registration page and use web-safe %3A = : %2F = /
$Scope = "DeviceManagementManagedDevices.Read.All" #Get from app registration page - search these with Graph Explorer or docs for reference
$AppSecret = 'k7b7OQasdfasdfasdfatq5Fq2PX~' #get from app registration page
$TenantName = "TENANT.onmicrosoft.com"

$outputFile = "C:\temp\IntuneDetectedAppsManagedDevices.csv"

$delegatedURLendpoint = "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/authorize?client_id=$AppId&response_type=code&redirect_uri=$redirectURI&response_mode=query&scope=$Scope&state=12345"
#copy this to browser where you are logged in with the account you are delegating as and copy the response
$delegatedURLendpoint | clip #now it's on your clipboard
#####RUN THE ABOVE CODE FIRST 

###DID YOU RUN IT?!
Write-Host "GO TO BROWSER WHERE YOU ARE ALREADY SIGNED IN AS THE ACCOUNT YOU ARE DELEGATED AS (admin account) AND PASTE FROM YOUR CLIPBOARD OR COPY THE BELOW URL" -ForegroundColor Cyan
Write-Host $delegatedURLendpoint -ForegroundColor Cyan
$fromBrowser = Read-Host "Copy the returned URL and paste it here.  The authorization code will be parsed."


#####GO TO WEB BROWSER ALREADY SIGNED INTO ACCOUNT WITH INTUNE RIGHTS, PASTE, THEN COPY THE URL RETURNED INTO $fromBrowser
#example URL
#http://localhost/?code=0.ARcAq5Mtt3E9DU-qGafsdaAyYE_2-fz0re9GjaKWggXP9BgXABk.AQABAAIAAABeStGSRwwnTq2vHplZ9KL4X0-NZZIbFaeGRKoL9Lp_IiSBrLtCt3Ty2hjOwM7KRUv_EIvCBqGHe-7fo6f4mtSG9xuHBRPbD_xjVrfbYmuc1FxBzxLDAzDer6-RzP5-vQH2aUZZQlh6CT2fK49zswJPHHMu7B3bTx-bcKOGWuCH-eZCtn7YnjxPSCReKieGORoKnOJHc1zNIJQlyVYrGtL1d16Ws9K7a2qXMAXp5s69XhCQRQGTf_iKY-NqA68owMS5_oQNwOUDSxKS8iR6LW6uorfpDBI8JS7TOhJMhbv-4HzL89OILufBmyIYfk4_8wlZJH5fFe0L5XrUNmiU9r37thUi348jeYA2rv6_BSianxsIbh9GGsNRAxO_qF1J_eG8-au8z4S3hMABpiX2bGz1rKcV0bsJUiFKxFOMdo4yqau3Nyt01yCm0LGh8Wb8vFUUwzlw3HdVNPGGU1ftk-XJtto6v6cCRxSrEKahKpq-BPwTgMt0v78XMIW3-nonHaBVovfaGH9nyEPubeKzwL07XerxUhan3FtyPTzmByczA3dK5VOikWvCFhYM53cGnjV3lmVwYDAZ7sBzF8IKUSCRSLq-XIW-l6GK0t3IkC04O2_uo3LUqWy-9VkayKkpwFz1qwW1Nf5hcg5h8qfcXFc5TpBb9MLKgl_gB89Jx1MC1iAA&state=12345&session_state=1b185ff0-08a2-494f-b808-79f742d71861#
#debug code
#$fromBrowser = "http://localhost/?code=0.ARasdf3E9DU-qGCZnKaAyYE_2-fz0re9GjaKWggXP9BgXABk.AQABAAIAAABeStGSRwwnTq2vHplZ9KL4X0-NZZIbFaeGRKoL9Lp_IiSBrLtCt3Ty2hjOwM7KRUv_EIvCBqGHe-7fo6f4mtSG9xuHBRPbD_xjVrfbYmuc1FxBzxLDAzDer6-RzP5-vQH2aUZZQlh6CT2fK49zswJPHHMu7B3bTx-bcKOGWuCH-eZCtn7YnjxPSCReKieGORoKnOJHc1zNIJQlyVYrGtL1d16Ws9K7a2qXMAXp5s69XhCQRQGTf_iKY-NqA68owMS5_oQNwOUDSxKS8iR6LW6uorfpDBI8JS7TOhJMhbv-4HzL89OILufBmyIYfk4_8wlZJH5fFe0L5XrUNmiU9r37thUi348jeYA2rv6_BSianxsIbh9GGsNRAxO_qF1J_eG8-au8z4S3hMABpiX2bGz1rKcV0bsJUiFKxFOMdo4yqau3Nyt01yCm0LGh8Wb8vFUUwzlw3HdVNPGGU1ftk-XJtto6v6cCRxSrEKahKpq-BPwTgMt0v78XMIW3-nonHaBVovfaGH9nyEPubeKzwL07XerxUhan3FtyPTzmByczA3dK5VOikWvCFhYM53cGnjV3lmVwYDAZ7sBzF8IKUSCRSLq-XIW-l6GK0t3IkC04O2_uo3LUqWy-9VkayKkpwFz1qwW1Nf5hcg5h8qfcXFc5TpBb9MLKgl_gB89Jx1MC1iAA&state=12345&session_state=1b185ff0-08a2-494f-b808-79f742d71861#"
$fromBrowser -match "\?code=(.*)\&state=" | Out-Null
$code = $matches[1]
$ReqTokenBody = @{
    Grant_Type    = "authorization_code"
    client_Id     = $AppId
    code          = $code
    redirect_uri  = "http://localhost"
    client_secret = $AppSecret


} 
#####AT THIS POINT, BEFORE NEXT LINE IS RUN, WE HAVE AN AUTH CODE MEANING OUR USER ACCOUNT IS AUTHENTICATED TO AZURE AD FOR THE APP, BUT THE CODE NEEDS TO BE EXCHANGED FOR A TOKEN THAT THE GRAPHAPI ENDPOINTS EXPECT
$Tokenresult = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

#####AT THIS POINT WE HAVE A TOKEN THAT CAN BE USED TO AUTHENTICATE TO THE GRAPHAPI ENDPOINTS $tokenresult.accces_token
# Create header
#can get auth header from Graph Explorer until can figure out app permissions..
$Header = @{
    Authorization = "Bearer $($Tokenresult.access_token)"
}


#EVERYTHIGN ABOVE THIS IS JUST GETTING AUTHORIZED TO HIT THE ENDPOINT
#https://graph.microsoft.com/v1.0/deviceManagement/detectedApps/ffdd715455beb2a308b25a963d181340206b2726a8f5c964ee9d6b3dda89982a/managedDevices
$uri = "https://graph.microsoft.com/v1.0/deviceManagement/detectedApps/"

# Fetch all detected apps
$detectedApps = Invoke-RestMethod -Uri $Uri -Headers $Header -Method Get -ContentType "application/json"

function Get-DetectedApps {
    $detectedApps.value
    $detectedApps.'@odata.nextLink' -match "skip=(.*)" | out-null
    [int]$skipValue = $Matches[1]

    $totalValue = $detectedApps.'@odata.count' - $detectedApps.'@odata.count' % $skipValue + $skipValue
    for ($i = $skipValue; $i -lt $totalValue; $i+=$skipValue) {
            $moreObj = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/deviceManagement/detectedApps/?`$skip=$i" -Headers $Header -Method Get -ContentType "application/json"
            $moreObj.value

    }
}

$allDetectedApps = Get-DetectedApps
function Get-DetectedAppsManagedDevices ($allDetectedApps) {
    $count = 0
    foreach ($app in $allDetectedApps) {
        Write-Progress -PercentComplete ($count / ($AlldetectedApps.Count * 100)) -Activity "Processing app $($app.displayname): $count of $($AlldetectedApps.Count)" -Status "Retrieving devices for app"
        $count++
        function Get-ManagedDevicesForApp ($app) {
            $appDevices = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/deviceManagement/detectedApps/$($app.id)/managedDevices" -Headers $Header -Method Get -ContentType "application/json"
            $appDevices.value
            if ($appDevices.'@odata.nextLink') {
                $appDevices.'@odata.nextLink' -match "skip=(.*)" | out-null
                [int]$skipValue = $Matches[1]

                $totalValue = $appDevices.'@odata.count' - $appDevices.'@odata.count' % $skipValue + $skipValue
                for ($i = $skipValue; $i -lt $totalValue; $i+=$skipValue) {
                         Write-Progress -PercentComplete ($i / $totalvalue * 100) -Activity "Processing app $app.displayname device pages $i of $totalvalue" -Status "Retrieving next page of devices"
                        $moreObj = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/deviceManagement/detectedApps/$($app.id)/managedDevices/?`$skip=$i" -Headers $Header -Method Get -ContentType "application/json"
                        $moreObj.value
                }
            }
    }
    $devices = Get-ManagedDevicesForApp -app $app

        
        foreach ($device in $devices) {
            $props = [ordered]@{
                appid = $app.id
                appdisplayname = $app.displayName
                appversion = $app.version
                id = $device.id
                devicename = $device.devicename
                operatingSystem = $device.operatingsystem
                osversion = $device.osversion
                emailaddress = $device.emailaddress
                serialnumber = $device.serialnumber
                phonenumber = $device.phonenumber
            }
            $obj = new-object -TypeName psobject -Property $props
            $obj
        }
    }
}
$fulllist = Get-DetectedAppsManagedDevices -allDetectedApps $allDetectedApps
$fulllist | export-csv $outputFile -NoTypeInformation
