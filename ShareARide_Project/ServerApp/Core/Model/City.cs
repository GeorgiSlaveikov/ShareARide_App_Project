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
        private string name = string.Empty;
        private double latitude;
        private double longitude;

        public City()
        {
        }

        public City(int id, string name)
        {
            Id = id;
            Name = name;
        }

        public City(int id, string name, double latitude, double longitude)
        {
            Id = id;
            Name = name;
            Latitude = latitude;
            Longitude = longitude;
        }

        public virtual int Id
        {
            get => id;
            set => id = value;
        }

        public string Name
        {
            get => name;
            set => name = value;
        }

        public double Latitude
        {
            get => latitude;
            set => latitude = value;
        }

        public double Longitude
        {
            get => longitude;
            set => longitude = value;
        }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.AppendLine($"City: {Name}");
            stringBuilder.AppendLine($"Latitude: {Latitude}");
            stringBuilder.AppendLine($"Longitude: {Longitude}");
            return stringBuilder.ToString();
        }
    }
}
    }
}
