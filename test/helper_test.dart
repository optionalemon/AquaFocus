import 'package:AquaFocus/screens/FocusTimer/CountDown/countdown_helper.dart';
import 'package:test/test.dart';

void main() {
  test("Function should return ['00','00','00']", () {
    expect(CountDownHelper().timeString(0),['00','00','00']);
  });

  test("Function should return ['00','01','00']", () {
    expect(CountDownHelper().timeString(60),['00','01','00']);
  });

  test("Function should return ['01','00','00']", () {
    expect(CountDownHelper().timeString(3600),['01','00','00']);
  });

  test("Function should return ['01','59','59']", () {
    expect(CountDownHelper().timeString(7199),['01','59','59']);
  });
}

