class CustomDropDownItem {
  String value;
  String text;
  CustomDropDownItem({
    required this.value,
    required this.text,
  });

  toJson() {
    return {
      'value': value,
      'text': text,
    };
  }
}
