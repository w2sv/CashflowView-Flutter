extension DoubleExtensions on double{
  double rounded(int decimalPlaces) => double.parse(toStringAsFixed(decimalPlaces));
}