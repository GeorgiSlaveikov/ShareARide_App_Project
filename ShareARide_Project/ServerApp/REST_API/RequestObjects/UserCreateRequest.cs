using Core.Others;
using System.ComponentModel.DataAnnotations;

namespace REST_API.RequestObjects
{
    public class UserCreateRequest
    {
        [Required]
        [StringLength(50, MinimumLength = 3)]
        public string Username { get; set; }

        [Required]
        public string FirstName { get; set; }

        [Required]
        public string LastName { get; set; }

        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [MinLength(8)]
        public string Password { get; set; }

        public string PhoneNumber { get; set; }

        public DateTime BirthDate { get; set; }

        public Sex Sex { get; set; }

        public IFormFile? ProfilePicture { get; set; }
    }
}
