using Core.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseLayer.DatabaseModels
{
    public class DatabaseOffer : Offer
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public override int Id { get; set; }
        public int DriverId { get; set; }
        public int VehicleId { get; set; }
        public int DepartureCityId { get; set; }
        public int DestinationCityId { get; set; }


        [ForeignKey("DriverId")]
        public virtual DatabaseUser DatabaseDriver { get; set; }

        [ForeignKey("DepartureCityId")]
        public virtual DatabaseCity DatabaseDepartureCity { get; set; }

        [ForeignKey("DestinationCityId")]
        public virtual DatabaseCity DatabaseDestinationCity { get; set; }
    }
}
