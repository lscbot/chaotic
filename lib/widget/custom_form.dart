part of widgets;

class CustomForm extends StatelessWidget {
  final Widget form;
  final String image;
  final String? text, tag;
  final int marginTopPercent;
  final double imageRadius;
  final void Function() onPress;
  final Color shadowColor;

  const CustomForm({
    required this.form,
    required this.onPress,
    required this.image,
    this.shadowColor = Colors.black,
    this.imageRadius = 40,
    this.marginTopPercent = 15,
    this.text,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: get_height(marginTopPercent),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            offset: const Offset(4, 8),
            blurRadius: 100,
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: imageRadius,
              bottom: 25,
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: form,
          ),
          Positioned(
            top: -imageRadius,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: shadowColor,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: shadowColor,
                radius: imageRadius,
                child: Image.asset(
                  get_asset_image(image),
                  width: imageRadius,
                  height: imageRadius,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -25,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: onPress,
                child: CustomText(
                  text: text ?? tr(tag!),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
