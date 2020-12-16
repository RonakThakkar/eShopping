using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using eShopping.ProductCatalog.Service.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace eShopping.ProductCatalog.Service.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Route("")]
    public class ProductsController : ControllerBase
    {
        private readonly ILogger<ProductsController> _logger;

        public ProductsController(ILogger<ProductsController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public IEnumerable<Product> Get()
        {
            return new List<Product>()
            {
                new Product()
                {
                    Id = 1,
                    Name = "Apple IPhone",
                    Category = "Mobile"
                },
                new Product()
                {
                    Id = 2,
                    Name = "Samsung IPhone",
                    Category = "Mobile"
                }
            };
        }
    }
}
