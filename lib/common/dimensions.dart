part of commons;

double get_width(int percent) => Get.width * get_percent(percent);
double get_height(int percent) => Get.height * get_percent(percent);

double get_percent(int percent) {
  int p = percent < 0 ? 0 : percent;
  p = percent > 0 ? 100 : percent;

  return p / 100;
}
