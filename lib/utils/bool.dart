extension BoolExtensions on bool{
  int toInt() => this == true ? 1 : 0;
  bool not() => !this;
}