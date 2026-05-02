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
    public class DatabaseBooking : Booking
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public override int Id { get; set; }
        public int OfferId { get; set; }
        public int RequesterId { get; set; }
        public int RequestedForId { get; set; }
        public int? RideId { get; set; }


        [ForeignKey("OfferId")]
        public virtual DatabaseOffer DatabaseOffer { get; set; }

        [ForeignKey("RequesterId")]
        public virtual DatabaseUser DatabaseRequester { get; set; }

        [ForeignKey("RequestedForId")]
        public virtual DatabaseUser DatabaseRequestedFor { get; set; }

        [ForeignKey("RideId")]
        public virtual DatabaseRide? DatabaseRide { get; set; }
    }
}
