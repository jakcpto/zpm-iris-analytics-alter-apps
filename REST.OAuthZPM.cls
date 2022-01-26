Class REST.OAuthZPM Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/auth" Method="GET" Call="auth" />
<Route Url="/check" Method="GET" Call="check" />
</Routes>
}

Parameter APPLICATION = "azpm";

Parameter REDIRECTURI = "https://pm.community.intersystems.com/zpmoauth/auth";

Parameter AUTHAPPURL = "https://pm.community.intersystems.com/zpm/tableau.csp";

parameter SCOPE = "openid profile email";

Parameter UseSession = 1;

ClassMethod auth()
{
	set isAuthorized = ##class(%SYS.OAuth2.AccessToken).IsAuthorized(
    	..#APPLICATION,
    	.sessionId,
    	..#SCOPE,
    	.accessToken,
    	.idtoken,
    	.responseProperties,
    	.error)
    	
    if isAuthorized {
		&html<<script type="text/javascript"> window.location="#(..#AUTHAPPURL)#" </script>>
		return $$$OK
	} 
	
	set url = ##class(%SYS.OAuth2.Authorization).GetAuthorizationCodeEndpoint(
    	..#APPLICATION,
    	..#SCOPE,
    	..#REDIRECTURI,
    	.properties,
    	.isAuthorized,
    	.sc)
	if $$$ISERR(sc) return sc
	//&html<<a href="#(url)#">Link</a>>
	&html<<script type="text/javascript"> window.location="#(url)#" </script>>
	return $$$OK
}

ClassMethod check()
{
	w {"url": "/zpm/zpmoauth/auth"}.%ToJSON()
	return $$$OK
}

}
