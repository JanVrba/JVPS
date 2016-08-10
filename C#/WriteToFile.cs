using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {        
            string text = "Alien Starting!!";
            // Write the text to a new file named "WriteFile.txt".
            File.WriteAllText(@"C:\Temp\WriteFile.txt", text);
        }       

    }
    
}
