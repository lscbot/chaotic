part of init;

extension on String {
  String toCamelcase() {
    final camelcase = StringBuffer();
    split('_').forEach((namePart) => camelcase.write(
        '${namePart.trim()[0].toUpperCase()}${namePart.trim().substring(1)}'
            .trim()));

    return camelcase.toString();
  }
}
