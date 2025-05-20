
String truncateFront({required final String text, required final int maxChars})
{
  const String ellipsis = "...";
  if (text.length > maxChars)
  {
    return "...${text.substring(text.length - maxChars + ellipsis.length)}";
  }
  else
  {
    return text;
  }
}

String formatDuration({required final int seconds})
{
  final int hours = seconds ~/ 3600;
  final int minutes = (seconds % 3600) ~/ 60;
  final int remainingSeconds = seconds % 60;
  final String formattedMinutes = minutes.toString().padLeft(2, '0');
  final String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

  if (hours > 0)
  {
    final String formattedHours = hours.toString().padLeft(2, '0');
    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  }
  else
  {
    return '$formattedMinutes:$formattedSeconds';
  }
}
