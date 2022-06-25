class CountDownHelper {
  int countMoney(int minutes) {
    return minutes;
  }

  List timeString(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return [hoursStr,minutesStr,secondsStr];
  }
}
