extension EnumExtensions on Enum{
  int compareTo(Enum other) => index.compareTo(other.index);
}