part of widgets;

class CustomDropDown<T> extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final List<CustomDropItem<T>>? items;
  final void Function(T? newValue)? onChange;
  final T? value;

  const CustomDropDown({
    this.icon,
    this.label = '',
    this.items,
    this.onChange,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                color: Colors.grey,
              ),
            const SizedBox(width: 5),
            CustomText(
              text: label,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(blurRadius: 1),
            ],
          ),
          child: items != null && items!.isNotEmpty
              ? DropdownButtonFormField<T>(
                  value: value,
                  isExpanded: true,
                  validator: (value) => value != null ? null : '',
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                  items: items
                          ?.map(
                            (item) => DropdownMenuItem(
                              value: item.value,
                              child: CustomText(
                                text: item.text,
                                maxLines: 2,
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                  onChanged: onChange,
                )
              : const SpinKitRipple(
                  color: Colors.black,
                ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class CustomDropItem<T> {
  final String text;
  final T value;

  CustomDropItem(this.text, this.value);
}
