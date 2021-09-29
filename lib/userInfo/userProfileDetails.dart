class UserProfileDetails {
  var username;
  var uid;
  var email;
  var session;
  var image;
  var phone;
  var address;

  UserProfileDetails(
      {this.phone,
      this.email,
      this.username,
      this.uid,
      this.session,
      this.image,
      this.address});
  getImage() {
    return image;
  }

  getphone() {
    return phone;
  }

  getuid() {
    return uid;
  }

  getusername() {
    return username;
  }

  getsession() {
    return session;
  }

  getemail() {
    return email;
  }

  getaddress() {
    return address;
  }
}
