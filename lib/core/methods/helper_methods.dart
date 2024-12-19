String formatDate(DateTime date) {
  const List<String> months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
  return "${date.day} ${months[date.month - 1]}, ${date.year}";
}