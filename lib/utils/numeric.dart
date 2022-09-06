extension DoubleExtensions on double{
  double rounded(int decimalPlaces) => double.parse(toStringAsFixed(decimalPlaces));
}

extension IntExtensions on int{
  bool toBool() => this == 0 ? false : true;
}