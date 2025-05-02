import 'package:uuid_type/uuid_type.dart';

class UuidGenerator {
  const UuidGenerator._();

  static Uuid id() => TimeUuidGenerator().generate();

  static String stringId() => id().toString();
}

void main() {
  print(UuidGenerator.stringId());
}
