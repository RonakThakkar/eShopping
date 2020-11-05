using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using eShopping.Customers.Service.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace eShopping.Customers.Service.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CustomersController : ControllerBase
    {
        private readonly ILogger<CustomersController> _logger;
        public CustomersController(ILogger<CustomersController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public IEnumerable<Customer> Get()
        {
            return new List<Customer>()
            {
                new Customer()
                {
                    Id = 1,
                    Name = "Ronak",
                    Address = "Pune"
                },
                new Customer()
                {
                    Id = 2,
                    Name = "Payal",
                    Address = "Pune"
                }
            };
        }
    }
}
