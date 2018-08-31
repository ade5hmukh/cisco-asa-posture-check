assert(function()
   
local os_connection = false
local av_connection = false
local cert = false
local update_days = "15"
local av_lastupdate = update_days * 86400
local av_message = "Antivirus is not installed, or virus definitions are out of date. Please install and update antivirus.\n\n"
local os_message = "Please remediate above issue(s) as soon as possible to enable your continued access to the VPN. For details go to url://vpninfo"
-- OS check
if(
  (CheckAndMsg((EVAL(endpoint.os.version, "EQ", "Windows XP", "caseless")),
    "Windows XP is not supported. Please upgrade to Windows 7 Service Pack 1 or Windows 8.1 and higher.\n",nil)) or
  (CheckAndMsg((EVAL(endpoint.os.version, "EQ", "Windows 8", "caseless")),
    "Windows 8 is not supported. Please upgrade to Windows 7 Service Pack 1 or Windows 8.1 and higher.\n",nil)) or
  (CheckAndMsg((EVAL(endpoint.os.version, "EQ", "Windows Vista", "caseless")),
    "Windows Vista is not supported. Please upgrade to Windows 7 Service Pack 1 or Windows 8.1 and higher.\n",nil))
 )then
os_connection= true
end
-- AV check
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
--Certificate check
  for k,v in pairs(endpoint.certificate.user) do
             if (v.issuer_cn == "Common Issuer CA" ) then
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
