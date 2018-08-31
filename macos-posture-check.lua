assert(function()
  
local os_connection = false
local av_connection = false
local cert = false
local update_days = "15"
local av_lastupdate = update_days * 86400
local av_message = "Antivirus is not installed, or virus definitions are out of date. Please install and/or update your antivirus.\n\n"
local os_message = "Please remediate above issue(s) as soon as possible to enable your continued access to the VPN. For details go to url://vpninfo"
if((CheckAndMsg((EVAL(endpoint.os.servicepack, "LT", "10.11", "caseless")),
    "Your Mac OS version is not supported. Please update to 10.11 or higher.\n",nil))
 )then
os_connection= true
end
for k, v in pairs(endpoint.av) do
     if (
   EVAL(v.exists, "EQ", "true", "string") and
   EVAL(v.lastupdate, "LT", av_lastupdate, "integer") and
   EVAL(v.activescan, "EQ", "ok", "string")
   ) then            
   av_connection=true
   break
     end
 end
--Cert check
  for k,v in pairs(endpoint.certificate.user) do
             if (v.issuer_cn == " Common Issuer 02 CA" ) then
                 cert=true
             end
         end
if ((os_connection == true) and (av_connection == true) and (cert == false))then
return CheckAndMsg(true, (os_message), nil)end --Incompatible OS | Compatible AV | Incompatible Cert
if ((os_connection == true) and (av_connection == false) and (cert == false))then
return CheckAndMsg(true, (av_message .. os_message), nil)end --Incompatible OS | Incompatible AV | InCompatible Cert
if ((os_connection == false) and (av_connection == false) and (cert == false))then
return CheckAndMsg(true, (av_message .. os_message), nil)end --Compatible OS | Incompatible AV | inCompatible Cert
end)()
