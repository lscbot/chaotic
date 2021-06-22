part of init;

extension on String {
  String to_camelcase() {
    final camelcase = StringBuffer();
    this.split('_').forEach((name_part) => camelcase.write(
        '${name_part.trim()[0].toUpperCase()}${name_part.trim().substring(1)}'
            .trim()));

    return camelcase.toString();
  }
}
