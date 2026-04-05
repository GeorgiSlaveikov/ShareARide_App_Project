using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Model
{
    public class City
    {
        private int id;
        private string name;

        public City() { }

        public City(int id, string name)
        {
            Id = id;
            Name = name;
        }

        public virtual int Id { get => id; set => id = value; }
        public string Name { get => name; set => name = value; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.AppendLine($"City: {Name}");
            return stringBuilder.ToString();
        }
    }
}
