using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;

namespace eShopping.Customers.Service
{
    // https://andrewlock.net/accessing-route-values-in-endpoint-middleware-in-aspnetcore-3/
    public class VersionMiddleware
    {
        private readonly RequestDelegate _next;
        static readonly Assembly _entryAssembly = System.Reflection.Assembly.GetEntryAssembly();
        static readonly string _name = FileVersionInfo.GetVersionInfo(_entryAssembly.Location).ProductName;
        static readonly string _version = FileVersionInfo.GetVersionInfo(_entryAssembly.Location).ProductVersion;

        public VersionMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext httpContext)
        {
            httpContext.Response.StatusCode = 200;
            httpContext.Response.ContentType = "text/plain";
            await httpContext.Response.WriteAsync(string.Format("{0}-{1}",_name,_version));
        }
    }

    // Extension method used to add the middleware to the HTTP request pipeline.
    public static class ProductVersionMiddlewareExtensions
    {
        private const string DefaultDisplayName = "Version Number";

        public static IEndpointConventionBuilder MapVersion(this IEndpointRouteBuilder endpoints, string pattern)
        {
            var pipeline = endpoints.CreateApplicationBuilder()
               .UseMiddleware<VersionMiddleware>()
               .Build();

            return endpoints.Map(pattern, pipeline).WithDisplayName(DefaultDisplayName);
        }
    }
}
