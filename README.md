# intunedetectedapps
using graph to query all your Intune detected apps on devices enrolled

Run this in PowerShell ISE or Powershell console, not VSCode - as the Read-Host with really long strings is broken.  The file will output in C:\temp\IntuneDetectedAppsManagedDevices.csv but can be changed with variable. Also the results will be in $fulllist after running the script.  Progress bars have been added for getting all apps, getting devices, and processing device pages.

Sites referenced when coming up with this:

https://blog.kloud.com.au/2016/08/10/enumerating-all-usersgroupscontacts-in-an-azure-tenant-using-powershell-and-the-azure-graph-api-odata-nextlink-paging-function/

https://developer.microsoft.com/en-us/graph/blogs/30daysmsgraph-day-7-paging-and-nextlink/

https://www.reddit.com/r/Office365/comments/jcam0t/intune_discovered_apps_graph_api_report/

https://docs.microsoft.com/en-us/graph/api/intune-devices-manageddevice-get?view=graph-rest-1.0

https://adamtheautomator.com/microsoft-graph-api-powershell/

You can use the output to filter for just detected apps on IOS devices!  You'll notice for Windows 10 devices, you only see UWP and other programs -- not all MSI or .exe programs are detected.

You have to setup an app registration in Azure AD and grant it the delegated permission   "DeviceManagementManagedDevices.Read.All" in order for this to work.  The account you use to browse the $delegatedURLendpoint needs to have intune rights.


There were about 71000 interations to go through in our environment because of how the relationships are formed with the Graph API. -- you have to get all detected apps, then for each app you have to query the devices.  You can't go devices -> detected apps... weird yea?

EG: get detected app -https://graph.microsoft.com/v1.0/deviceManagement/detectedApps

EG: get the devices that app is installed on (specifying the GUID of one of the previously found apps) https://graph.microsoft.com/v1.0/deviceManagement/detectedApps/ffdd715455beb2a308b25a963d181340206b2726a8f5c964ee9d6b3dda89982a/managedDevices


There is a MSAL.PS module to make authentication smoother, but I keep getting errors trying to get it to work, so this workflow has the browser intermediate step.. works for now!

I was originally using the auth token from the Graph Explorer to cheat the authorization until I figured out the problem.  If you have an app registration and you are providing the client secret, you are authorizing AS the app, and therefore need to give the application permissions in the app registration, however, certain GraphAPI endpoints don't support application permissions (such as Intune Managed Devices).  So you have to use the delegated permissions in the app registration permissions in AD.
That makes the powershell version of authentication a little more complicated, because you can't just spray out the clientid, clientsecret, and away you go.You have to authenticate to the app as your admin account, and get a delegated authorization code.  You then go back to the app with that auth code instead of clientsecret, and that's how you have delegated your admin account permissions in Intune through the app registration.
At that point, anything your admin account has access to(Intune Admin), provided you have also given the app registration permission to access (Intune Device Management Read All), you can hit the GraphAPI endpoints to use.

I followed instructions here to clear history when I had actual IDs in original upload:

https://tecadmin.net/delete-commit-history-in-github/#:~:text=Delete%20Commit%20History%20in%20Github%20Repository%201%20Create,from%20your%20git%20repository.%20...%20More%20items...