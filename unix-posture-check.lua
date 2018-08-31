assert(function()
local av_connection = false
local update_days = "15"
local av_lastupdate = update_days * 86400
local av_message = "Antivirus is not installed, or virus definitions are out of date. Please update then try again.\n\n Please remediate the above issue(s) as soon as possible to enable your access to VPN. For details go to url://vpninfo"
for k, v in pairs(endpoint.av) do
     if (
   EVAL(v.exists, "EQ", "true", "string") and
   EVAL(v.lastupdate, "LT", av_lastupdate, "integer")
   ) then           
   av_connection=true
   break
     end
 end
if (av_connection == false)then return CheckAndMsg(true, av_message, nil)end
end)()
