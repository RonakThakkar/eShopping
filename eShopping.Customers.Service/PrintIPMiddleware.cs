using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace eShopping.Customers.Service
{
    public class PrintIPMiddleware
    {
        private readonly RequestDelegate _next;
        static string HostName = Dns.GetHostName();
        string ipaddress = String.Join(",", Dns.GetHostEntry(HostName).AddressList.Select(x => x.ToString()));
        //string ipaddress = String.Join(",", Dns.GetHostAddresses(HostName).Select(x => x.ToString()));

        public PrintIPMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext httpContext)
        {
            httpContext.Response.StatusCode = 200;
            httpContext.Response.ContentType = "text/plain";

            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.AppendLine(String.Format("HostName = {0}", HostName));
            stringBuilder.AppendLine(String.Format("IPAddress = {0}", ipaddress));
            await httpContext.Response.WriteAsync(stringBuilder.ToString());
        }
    }

    // Extension method used to add the middleware to the HTTP request pipeline.
    public static class PrintIPMiddlewareExtensions
    {
        private const string DefaultDisplayName = "Print HostName and IP Address";

        public static IEndpointConventionBuilder MapPrintIP(this IEndpointRouteBuilder endpoints, string pattern)
        {
            var pipeline = endpoints.CreateApplicationBuilder()
               .UseMiddleware<PrintIPMiddleware>()
               .Build();

            return endpoints.Map(pattern, pipeline).WithDisplayName(DefaultDisplayName);
        }
    }
}
