using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Configuration;
using System.Runtime.ExceptionServices;

namespace MonitoringASPNETApplication
{
    public class Global : System.Web.HttpApplication
    {
        string _item = "__RequestExceptionKey";
        protected void Application_Start()
        {
            SetupMonitoring();
        }

        private void SetupMonitoring()
        {
            bool appDomainMonitoringEnabled, firstChanceExceptionMonitoringEnabled;
            bool.TryParse(ConfigurationManager.AppSettings["AppDomainMonitoringEnabled"], out appDomainMonitoringEnabled);
            bool.TryParse(ConfigurationManager.AppSettings["FirstChanceExceptionMonitoringEnabled"], out firstChanceExceptionMonitoringEnabled);
            if (appDomainMonitoringEnabled)
            {
                AppDomain.MonitoringIsEnabled = true;
            }
            if (firstChanceExceptionMonitoringEnabled)
            {
                AppDomain.CurrentDomain.FirstChanceException += (object source, FirstChanceExceptionEventArgs e) =>
                {
                    if (HttpContext.Current == null)// If no context available, ignore it
                        return;
                    if (HttpContext.Current.Items[_item] == null)
                        HttpContext.Current.Items[_item] = new RequestException { Exceptions = new List<Exception>() };
                    (HttpContext.Current.Items[_item] as RequestException).Exceptions.Add(e.Exception);
                };
            }
        }
        protected void Application_EndRequest()
        {
            if (Context.Items[_item] != null)
            {
                //Only add the request if atleast one exception is raised
                var reqExc = Context.Items[_item] as RequestException;
                reqExc.Url = Request.Url.AbsoluteUri;
                Application.Lock();
                if (Application["AllExc"] == null)
                    Application["AllExc"] = new List<RequestException>();
                (Application["AllExc"] as List<RequestException>).Add(reqExc);
                Application.UnLock();
            }
        }
    }
}