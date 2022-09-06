extension BoolExtensions on bool{
  int toInt() => this == true ? 1 : 0;
  int toOpposingInt() => this == true ? 1 : -1;  // TODO: find better name
  bool not() => !this;
}