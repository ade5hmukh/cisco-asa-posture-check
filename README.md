Readme for Cisco ASA posture checking using local hostscan features 

Pre-requisites:

Configure Host Scan functionality on the Cisco ASA
We leverage Dynamic Access Policies (DAPs) to configure lua scripts for posture assessments. 
DAPs are processed in order of priority.

Configuration:
Add a new Dynamic Access Policy via the “Add” button. Give this policy an appropriate name, e.g. “Win OS + Antivirus Check”, and an appropriate description. 
In order to prevent this check from running on incompatible/unintended operating systems (such as Mac/iOS/Android mobile systems), we will want to configure the policy to only be enforced when a specific list of operating systems are detected.
This can be accomplished by selecting appropriate AAA and/or endpoint attributes. 

Lua Script Setup

Within this same new “Win OS + Antivirus Check” policy, we must now configure the actual Antivirus/etc. engine detection mechanism. This is done manually via a Lua script that is configured under the “Advanced” action. Click the double-arrow twisty to the right of “Advanced” to open this menu:
For this policy, ensure that the option under Advanced is set to “AND”. The Lua script we’ll use here must be configured to return a Boolean value of “True” if the end-user device is detected as out-ofcompliance, and thus this value AND’ed with the Operating System list given in the “Selection Criteria” box above will either take the default action of “Terminate” if a device is determined to be out of compliance. Otherwise, if the Lua script returns the value “False”, the “AND” condition of both the Lua script and Selection Criteria will not evaluate to True, and this entire DAP will be ignored/take no action. 
While there is some limited documentation available from Cisco on configuration of the Lua script by clicking on the “Guide” button to the right of the input window, many of the examples are either limited in scope, incomplete or generally inaccurate. There are further configuration examples available from various sources online, but it is generally advised that any additional configuration beyond the scope of this guide be performed under advisement of Cisco TAC.

Windows-posture-check.lua checks for Compatible Operating system, Antivirus (exists, last updated and activescan running) and Certificate 
macos-posture-check.lua checks for Compatible Operating system, Antivirus (exists, last updated and activescan running) and Certificate
linux-posture-check.lua checks for Antivirus (exists and last updated)

n the end, if an end-user’s device does not have an approved Operating System and antivirus package that meets all three of the conditions evaluated in the for loop, which will be AND’ed against the Selection Criteria above and the default action of “Terminate” will be taken, and the appropriate Message will be displayed. 

Note that we are evaluating “activescan” (real-time scanning/protection) in this script, and that Host Scan cannot evaluate this condition for every Antivirus program given in the supported list document. Ensure that this feature is marked as “supported” for whatever software package the end-user is running. It is strongly recommended that any IT support staff be given this list to help them quickly make this determination when evaluating VPN connection issues reported by endusers.  

Once this DAP is configured appropriately, go ahead and click “OK”, then apply the configuration and Save. Note that any modifications made to the Lua script itself will not be displayed in the Code Preview window when you click “Apply”, but a message will be displayed indicating the “No CLI changes were made, but Dynamic Access Policy Selection file needs to be updated.” 
