using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Model
{
    public class Rating
    {
        private int id;
        private int score;
        private string? comment;
        private DateTime createdAt;

        public Rating()
        {
            CreatedAt = DateTime.Now;
        }

        public virtual int Id { get => id; set => id = value; }

        public int Score
        {
            get => score;
            set
            {
                if (value < 1 || value > 5)
                    throw new ArgumentOutOfRangeException(nameof(Score), "Score must be between 1 and 5.");

                score = value;
            }
        }

        public string? Comment { get => comment; set => comment = value; }

        public DateTime CreatedAt { get => createdAt; set => createdAt = value; }
    }
}
