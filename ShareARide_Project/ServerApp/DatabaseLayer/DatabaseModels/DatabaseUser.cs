using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Core.Model;

namespace DatabaseLayer.DatabaseModels
{
    public class DatabaseUser : User
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public override int Id { get; set; }

        public int? HomeCityId { get; set; }

        [ForeignKey("HomeCityId")]
        public virtual DatabaseCity DatabaseHomeCity { get; set; }
    }
}
