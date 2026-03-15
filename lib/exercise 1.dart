T? maxOf<T extends Comparable>(List<T> list) {
  if (list.isEmpty) return null;
  return list.reduce((acc, item) => item.compareTo(acc) > 0 ? item : acc);
}

void main() {
  print(maxOf([3, 7, 2, 9])); // 9
  print(maxOf(["apple", "banana", "kiwi"])); // kiwi
  print(maxOf<int>([])); // null
}
