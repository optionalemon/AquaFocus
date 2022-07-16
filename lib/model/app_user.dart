class AppUser {
  String uid = '';
  String email = '';
  String userName = '';
  List<int> marLives = [];
  List<String> tags = ['Work','Study'];
  int fishMoney = 0;
  bool isCheckList = true;
  bool allowNotif = true;

  AppUser({
    required this.email,
    required this.userName,
  });
}
