<%@ Page Language="C#" %>
<%@ Import Namespace="MonitoringASPNETApplication" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Monitoring ASP.NET Application</title>
    <script src="<%= ResolveUrl("~/jquery-1.4.4.min.js") %>" type="text/javascript"></script>
    <style type="text/css">
        body
        {
            background: #1F4677 none repeat scroll 0 0;
            font-family: Verdana,Arial,Helvetica,sans-serif;
        }
        h1, h2
        {
            text-decoration: underline;
        }
        .content
        {
            color: #333333;
            background: #D2E1F6 none repeat scroll 0 0;
            width: 940px;
            display: block;
            margin: 0 auto;
            padding-bottom: 30px;
        }
        .container
        {
            border: 1px solid;
            padding: 1px;
            margin-left: 15px;
            margin-right: 15px;
            background-color: #dddddd;
        }
        #wrapper
        {
            margin: 5px auto;
        }
        .ExpContent
        {
            padding: 1px;
            margin-left: 15px;
            margin-right: 15px;
            background-color: #dddddd;
        }
        .ExpLink
        {
            padding-left: 5px;
            text-decoration: underline;
        }
        .outerExpContent
        {
            display: none;
        }
    </style>
</head>
<%
        var listRequestException = Context.Application["AllExc"] as List<RequestException>;
        if (listRequestException == null)
        {
            listRequestException = new List<RequestException>();
        }
        var number = 1;
%>
<body>
    
         <div id="wrapper">
        <div class="content">
            <header>
                <h1>
                    Monitoring ASP.NET Application</h1>
                <p>
                    This page shows you the resource(memory or cpu) consumption by your application. This page also shows you all the exceptions
                    raised by your application whether they are swallowed or not.</p>
            </header>
            <div>
                <section id="content">
                    <article>
                        <h2>
                            Memory and CPU Consumption</h2>
                        <p class="container">
                            <b>Total Bytes Allocated:</b> <%: AppDomain.CurrentDomain.MonitoringTotalAllocatedMemorySize %> Bytes<br />
                            <br />
                            <b>Total Bytes In Use:</b> <%: AppDomain.CurrentDomain.MonitoringSurvivedMemorySize %> Bytes<br />
                            <br />
                            <b>CPU usage:</b> <%: AppDomain.CurrentDomain.MonitoringTotalProcessorTime.Milliseconds %> Milliseconds
                        </p>
                    </article>
                    <article>
                        <h2>
                            Exceptions</h2>
                        <% foreach (var reqExc in listRequestException)
                        {%>
                            <br /><a data-divid="outerexp<%: number %>" href="javascript:" class="ExpLink"><%: reqExc.Url %></a><br /><br />
                            <div id="outerexp<%: number %>" class="outerExpContent">
                                <% foreach (var ex in reqExc.Exceptions)
                                {%>
                                    <div class="ExpContent">
                                        <p>
                                            <b>Exception Type:</b> <%: ex.GetType().FullName%></p>
                                        <p>
                                            <b>Message:</b> <%: ex.Message %></p>
                                        <p>
                                            <b>Stack Trace:</b> <%: ex.StackTrace %></p>
                                            <hr />
                                    </div>                                    
                                <% } %>
                            </div>
                            <% number++;%>
                        <% } %>
                    </article>
                </section>
            </div>
        </div>
        <footer>
        </footer>
    </div>
    <script type="text/javascript">
        $(function () {
            $(".ExpLink").click(function () {
                $("#" + $(this).attr('data-divid')).slideToggle('slow');
            });
        });
    </script>
</body>
</html>
