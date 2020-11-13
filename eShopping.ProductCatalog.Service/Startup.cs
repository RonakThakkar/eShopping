using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace eShopping.ProductCatalog.Service
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddHealthChecks();
            services.AddControllers();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            // Option 1 - Adding VersionMiddleware before Routing Middleware.
            //app.Map("/version", versionApp => versionApp.UseMiddleware<VersionMiddleware>());

            // Add the EndpointRoutingMiddleware
            app.UseRouting();

            // All middleware from here onwards know which endpoint will be invoked
            app.UseAuthorization();

            // Adds the EndpointMiddleware to the pipeline. EndpointMiddleware will execute the endpoint selected by the routing middleware
            // Register all the endpoints for your application
            app.UseEndpoints(endpoints =>
            {
                // Option 2 - Adding VersionMiddleware as Routing Endpoint called by EndpointMiddleware.
                // https://andrewlock.net/converting-a-terminal-middleware-to-endpoint-routing-in-aspnetcore-3/
                endpoints.MapVersion("/version");
                endpoints.MapHealthChecks("/health");
                endpoints.MapControllers();
            });
        }
    }
}
