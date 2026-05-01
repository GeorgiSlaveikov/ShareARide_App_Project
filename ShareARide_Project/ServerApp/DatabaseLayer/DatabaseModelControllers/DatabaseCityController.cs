using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseLayer.DatabaseModelControllers
{
    public static class DatabaseCityController
    {
        public static List<string> cities = [
            "Sofia", "Plovdiv", "Varna", "Burgas", "Ruse", "Stara Zagora", "Pleven", "Sliven",
            "Dobrich", "Shumen", "Pernik", "Haskovo", "Yambol", "Pazardzhik", "Blagoevgrad",
            "Veliko Tarnovo", "Vratsa", "Gabrovo", "Asenovgrad", "Vidin", "Kazanlak", "Kyustendil",
            "Montana", "Kardzhali", "Dimitrovgrad", "Lovech", "Silistra", "Targovishte", "Razgrad",
            "Dupnitsa", "Smolyan", "Petrich", "Sandanski", "Samokov", "Lom", "Karlovo", "Nova Zagora",
            "Svishtov", "Gotse Delchev", "Troyan", "Aytos", "Botevgrad", "Panagyurishte",
            "Karnobat", "Svilengrad", "Chirpan", "Peshtera", "Popovo", "Rakovski", "Byala Slatina",
            "Ihtiman", "Nesebar", "Pomorie", "Sozopol", "Balchik", "Kavarna", "Mezdra", "Provadiya",
            "Radomir", "Kozloduy", "Cherven Bryag", "Berkovitsa", "Devnya", "Tutrakan", "Elin Pelin"
        ];

        public static readonly Dictionary<string, (double Latitude, double Longitude)> cityCoordinates = new()
        {
            ["Sofia"] = (42.6977, 23.3219),
            ["Plovdiv"] = (42.1354, 24.7453),
            ["Varna"] = (43.2141, 27.9147),
            ["Burgas"] = (42.5048, 27.4626),
            ["Ruse"] = (43.8356, 25.9657),
            ["Stara Zagora"] = (42.4258, 25.6345),
            ["Pleven"] = (43.4170, 24.6067),
            ["Sliven"] = (42.6817, 26.3229),
            ["Dobrich"] = (43.5726, 27.8273),
            ["Shumen"] = (43.2712, 26.9361),
            ["Pernik"] = (42.6052, 23.0378),
            ["Haskovo"] = (41.9344, 25.5556),
            ["Yambol"] = (42.4840, 26.5035),
            ["Pazardzhik"] = (42.1928, 24.3336),
            ["Blagoevgrad"] = (42.0209, 23.0943),
            ["Veliko Tarnovo"] = (43.0757, 25.6172),
            ["Vratsa"] = (43.2102, 23.5529),
            ["Gabrovo"] = (42.8742, 25.3187),
            ["Asenovgrad"] = (42.0074, 24.8774),
            ["Vidin"] = (43.9962, 22.8679),
            ["Kazanlak"] = (42.6194, 25.3930),
            ["Kyustendil"] = (42.2869, 22.6939),
            ["Montana"] = (43.4125, 23.2257),
            ["Kardzhali"] = (41.6420, 25.3687),
            ["Dimitrovgrad"] = (42.0560, 25.5933),
            ["Lovech"] = (43.1368, 24.7139),
            ["Silistra"] = (44.1147, 27.2672),
            ["Targovishte"] = (43.2467, 26.5722),
            ["Razgrad"] = (43.5337, 26.5411),
            ["Dupnitsa"] = (42.2667, 23.1167),
            ["Smolyan"] = (41.5774, 24.7011),
            ["Petrich"] = (41.3985, 23.2070),
            ["Sandanski"] = (41.5667, 23.2833),
            ["Samokov"] = (42.3370, 23.5528),
            ["Lom"] = (43.8211, 23.2367),
            ["Karlovo"] = (42.6428, 24.8055),
            ["Nova Zagora"] = (42.4929, 26.0127),
            ["Svishtov"] = (43.6196, 25.3504),
            ["Gotse Delchev"] = (41.5667, 23.7333),
            ["Troyan"] = (42.8943, 24.7159),
            ["Aytos"] = (42.7000, 27.2500),
            ["Botevgrad"] = (42.9077, 23.7936),
            ["Panagyurishte"] = (42.5048, 24.1908),
            ["Karnobat"] = (42.6500, 26.9833),
            ["Svilengrad"] = (41.7667, 26.2000),
            ["Chirpan"] = (42.2000, 25.3333),
            ["Peshtera"] = (42.0337, 24.2999),
            ["Popovo"] = (43.3500, 26.2333),
            ["Rakovski"] = (42.3000, 24.9667),
            ["Byala Slatina"] = (43.4667, 23.9333),
            ["Ihtiman"] = (42.4333, 23.8167),
            ["Nesebar"] = (42.6601, 27.7206),
            ["Pomorie"] = (42.5588, 27.6439),
            ["Sozopol"] = (42.4173, 27.6951),
            ["Balchik"] = (43.4079, 28.1615),
            ["Kavarna"] = (43.4333, 28.3333),
            ["Mezdra"] = (43.1500, 23.7000),
            ["Provadiya"] = (43.1833, 27.4333),
            ["Radomir"] = (42.5453, 22.9656),
            ["Kozloduy"] = (43.7786, 23.7206),
            ["Cherven Bryag"] = (43.2667, 24.1000),
            ["Berkovitsa"] = (43.2361, 23.1258),
            ["Devnya"] = (43.2222, 27.5694),
            ["Tutrakan"] = (44.0500, 26.6167),
            ["Elin Pelin"] = (42.6667, 23.6000)
        };

        public static (double Latitude, double Longitude) GetCoordinates(string cityName)
        {
            if (cityCoordinates.TryGetValue(cityName, out var coordinates))
            {
                return coordinates;
            }

            // fallback: approximate center of Bulgaria
            return (42.7339, 25.4858);
        }
    }
}
