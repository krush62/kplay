
import 'dart:math';

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

String generatePassword({required final int length})
{
  const String upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  const String lower = "abcdefghijklmnopqrstuvwxyz";
  const String numbers = "1234567890";
  const String seed = upper + lower + numbers;
  final int passLength = length.clamp(6, 16);
  String password = '';
  final List<String> list = seed.split('').toList();
  final Random rand = Random();
  for (int i = 0; i < passLength; i++) {
    final int index = rand.nextInt(list.length);
    password += list[index];
  }
  return password;
}
