import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:viewducts/E2EE/crc.dart';
import 'package:viewducts/helper/constant.dart';

class TextEncryptDecrypt {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static encryptAES(input) {
    final encrypted = encrypter.encrypt(input, iv: iv).base64;
    int crc = CRC32.compute(input);
    return '$encrypted$CRC_SEPARATOR$crc';
  }

  static decryptAES(input) {
    try {
      if (input.contains(CRC_SEPARATOR)) {
        int idx = input.lastIndexOf(CRC_SEPARATOR);
        String msgPart = input.substring(0, idx);
        String crcPart = input.substring(idx + 1);
        int? crc = int.tryParse(crcPart);
        if (crc != null) {
          msgPart =
              encrypter.decrypt(encrypt.Encrypted.fromBase64(msgPart), iv: iv);
          if (CRC32.compute(msgPart) == crc) return msgPart;
        }
      }
    } on FormatException {
      return 'there is error';
    }
    return '';
  }
}
