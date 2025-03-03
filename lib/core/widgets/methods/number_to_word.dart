String numberToWords(double number) {
  if (number == 0) {
    return "Zero"; // Uppercase "Zero"
  }

  final List<String> ones = [
    "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
    "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen",
    "Seventeen", "Eighteen", "Nineteen"
  ];

  final List<String> tens = [
    "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy",
    "Eighty", "Ninety"
  ];

  String convert(int num) {
    if (num < 20) {
      return ones[num];
    } else if (num < 100) {
      return tens[num ~/ 10] + (num % 10 != 0 ? " ${ones[num % 10]}" : "");
    } else if (num < 1000) {
      return "${ones[num ~/ 100]} Hundred${num % 100 != 0 ? " and ${convert(num % 100)}" : ""}";
    } else if (num < 1000000) {
      return "${convert(num ~/ 1000)} Thousand${num % 1000 != 0 ? " ${convert(num % 1000)}" : ""}";
    } else if (num < 1000000000) {
      return "${convert(num ~/ 1000000)} Million${num % 1000000 != 0 ? " ${convert(num % 1000000)}" : ""}";
    } else {
      return "${convert(num ~/ 1000000000)} Billion${num % 1000000000 != 0 ? " ${convert(num % 1000000000)}" : ""}";
    }
  }

  String convertFraction(double fraction) {
    String fractionStr = fraction.toStringAsFixed(6); // Convert the fraction to a string with a fixed precision
    fractionStr = fractionStr.substring(fractionStr.indexOf('.') + 1); // Get the fractional part

    List<String> fractionWords = [];
    for (int i = 0; i < fractionStr.length; i++) {
      fractionWords.add(ones[int.parse(fractionStr[i])]);
    }

    return "point ${fractionWords.join(" ")}";
  }

  // Split the number into integer and fractional parts
  int integerPart = number.toInt();
  double fractionalPart = number - integerPart;

  String integerWords = convert(integerPart);

  if (fractionalPart == 0) {
    return "${integerWords} Taka Only";
  } else {
    return "$integerWords ${convertFraction(fractionalPart)} Taka Only";
  }
}
