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
    public class DatabaseRating : Rating
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public override int Id { get; set; }

        public int RatedUserId { get; set; }

        public int RatedByUserId { get; set; }

        public int RideId { get; set; }

        [ForeignKey("RatedUserId")]
        public virtual DatabaseUser RatedUser { get; set; }

        [ForeignKey("RatedByUserId")]
        public virtual DatabaseUser RatedByUser { get; set; }

        [ForeignKey("RideId")]
        public virtual DatabaseRide Ride { get; set; }
    }
}
