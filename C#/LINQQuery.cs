using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            List<Car> myCars = new List<Car> {
                new Car { Name = "Ferrari" }  ,
                new Car { Name = "Lamborgini" }
            };

            var ferrari = from car in myCars
                          where car.Name == "Ferrari"
                          select car;

            /*  using orderby query
            var orderedCars = from car in myCars
                              orderby car.Name ascending
                              select car;
            */

            /* using LINQ method
            Method Where
            var ferrari = myCars.Where(kar => kar.Name == "Ferrari");
            Method orderby
            var orderedCars = myCars.OrderBy(c => c.Name); 
            Method Exists
            Console.WriteLine(myCars.Exists(p => p.Name == "Lamborgini"));

            /*  using orderby
            var orderedCars = from car in myCars
                              orderby car.Name ascending
                              select car;
            */

            foreach (var car in ferrari)
            {
                Console.WriteLine("{0}", car.Name);
            }

            foreach (var car in ferrari)
            {
                Console.WriteLine("{0}", car.Name);
            }

            Console.ReadLine();
            
        }
    };

    class Car
    {
        public string Name { get; set; }
    }
}
