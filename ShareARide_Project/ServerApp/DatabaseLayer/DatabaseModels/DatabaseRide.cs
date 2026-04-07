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
    public class DatabaseRide : Ride
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public override int Id { get; set; }

        public int OfferId { get; set; }

        [ForeignKey("OfferId")]
        public virtual DatabaseOffer DatabaseOffer { get; set; }

        public virtual ICollection<DatabaseBooking> DatabaseBookings { get; set; } = new List<DatabaseBooking>();
    }
}
