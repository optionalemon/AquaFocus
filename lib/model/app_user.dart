class AppUser {
  String uid = '';
  String email = '';
  String userName = '';
  List<int> marLives = [];
  int fishMoney = 0;
  bool isCheckList = true;
  bool allowNotif = true;

  AppUser({
    required this.email,
    required this.userName,
  });
}
