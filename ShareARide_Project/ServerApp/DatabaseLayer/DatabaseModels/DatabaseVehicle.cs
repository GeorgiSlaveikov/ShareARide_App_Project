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
    public class DatabaseVehicle : Vehicle
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public override int Id { get; set; }

        public int OwnerId { get; set; }

        [ForeignKey("OwnerId")]
        public virtual DatabaseUser DatabaseOwner { get; set; }
    }
}
