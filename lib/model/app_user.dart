class AppUser {
  String uid = '';
  String email = '';
  String userName = '';
  List<int> marLives = []; 
  int fishMoney = 0;

  AppUser({
    required this.email,
    required this.userName,
  });

  void setEmail(String email) {
    this.email = email;
  }

  void setuserName(String userName) {
    this.userName = userName;
  }
}
