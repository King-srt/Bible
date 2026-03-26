class ContentVersion implements Comparable<ContentVersion> {
  const ContentVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.raw,
  });

  final int major;
  final int minor;
  final int patch;
  final String? raw;

  factory ContentVersion.parse(String value) {
    final normalized = value.trim().toLowerCase().startsWith('v')
        ? value.trim().substring(1)
        : value.trim();
    final parts = normalized.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid content version: $value');
    }

    return ContentVersion(
      major: int.parse(parts[0]),
      minor: int.parse(parts[1]),
      patch: int.parse(parts[2]),
      raw: value,
    );
  }

  @override
  int compareTo(ContentVersion other) {
    final majorResult = major.compareTo(other.major);
    if (majorResult != 0) {
      return majorResult;
    }
    final minorResult = minor.compareTo(other.minor);
    if (minorResult != 0) {
      return minorResult;
    }
    return patch.compareTo(other.patch);
  }

  @override
  String toString() => 'v$major.$minor.$patch';
}
