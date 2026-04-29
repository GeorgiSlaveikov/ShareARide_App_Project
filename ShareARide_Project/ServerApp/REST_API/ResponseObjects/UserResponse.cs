using Core.Others;

namespace REST_API.ResponseObjects
{
    public class UserResponse
    {
        public int Id { get; set; }
        public string UserName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public int Age { get; set; }
        public string PhoneNumber { get; set; }
        public Sex Sex {  get; set; }
        public decimal Rating { get; set; }
    }
}
