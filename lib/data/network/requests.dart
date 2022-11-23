class LoginRequests {
  String email;
  String password;

  LoginRequests(this.email, this.password);
}

class RegisterRequests {
  String userName;
  String countryMobileCode;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;

  RegisterRequests(this.userName, this.countryMobileCode, this.mobileNumber,
      this.email, this.password, this.profilePicture);
}
