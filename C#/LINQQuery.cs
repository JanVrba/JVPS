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

            // using LINQ method
            // var ferrari = myCars.Where(kar => kar.Name == "Ferrari");

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
