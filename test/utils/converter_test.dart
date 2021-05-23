import 'package:flutter_test/flutter_test.dart';
import 'package:free_chat/src/utils/converter.dart';

void main() {
  group('Test base64 de- and encode', () {
    var encoded = "SGVsbG8gV29ybGQh";
    var decoded = "Hello World!";

    test('Should encode to base64', () {
      var stringEncoded = Converter.stringToBase64.encode(decoded);
      expect(stringEncoded, encoded);
    });


    test('Should decode from base64', () {
      var stringDecoded = Converter.stringToBase64.decode(encoded);
      expect(stringDecoded, decoded);
    });

  });
}