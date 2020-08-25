using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MonitoringASPNETApplication
{
    public class RequestException
    {
        public string Url { get; set; }
        public List<Exception> Exceptions { get; set; }
    }
}