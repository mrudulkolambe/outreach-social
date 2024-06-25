// String numberFormatter(int num) {
//   if (num > 999 && num < 99999) {
//     return "${(num / 1000).toStringAsFixed(1)}K";
//   } else if (num > 99999 && num < 999999) {
//     return "${(num / 1000).toStringAsFixed(0)}K";
//   } else if (num > 999999 && num < 999999999) {
//     return "${(num / 1000000).toStringAsFixed(1)}M";
//   } else if (num > 999999999) {
//     return "${(num / 1000000000).toStringAsFixed(1)}B";
//   } else {
//     return num.toString();
//   }
// }


String numberFormatter(int num) {
  if (num >= 1000 && num < 100000) {
    // If number is between 1000 and 99999, format with one decimal place
    return "${(num / 1000).toStringAsFixed(num % 1000 == 0 ? 0 : 1)}K";
  } else if (num >= 100000 && num < 1000000) {
    // If number is between 100000 and 999999, format without decimal place
    return "${(num / 1000).toStringAsFixed(0)}K";
  } else if (num >= 1000000 && num < 1000000000) {
    // If number is between 1000000 and 999999999, format with one decimal place
    return "${(num / 1000000).toStringAsFixed(num % 1000000 == 0 ? 0 : 1)}M";
  } else if (num >= 1000000000) {
    // If number is 1000000000 or more, format with one decimal place
    return "${(num / 1000000000).toStringAsFixed(num % 1000000000 == 0 ? 0 : 1)}B";
  } else {
    // If number is less than 1000, return the number as is
    return num.toString();
  }
}