enum Testament {
  old,
  newTestament,
}

extension TestamentX on Testament {
  static Testament fromString(String value) {
    return value.toLowerCase() == 'new' ? Testament.newTestament : Testament.old;
  }

  String get value => this == Testament.newTestament ? 'new' : 'old';
}
