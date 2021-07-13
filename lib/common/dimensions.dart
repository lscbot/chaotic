part of commons;

double getWidth(int percent) => Get.width * _getPercent(percent);
double getHeight(int percent) => Get.height * _getPercent(percent);

double _getPercent(int percent) {
  int p = percent < 0 ? 0 : percent;
  p = percent > 100 ? 100 : percent;

  return p / 100;
}
