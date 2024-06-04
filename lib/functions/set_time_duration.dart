String formatDurationInHhMmSs({required Duration duration}) {
  final HH = (duration.inHours).toString().padLeft(2, '0');
  final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
  final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');

  return '$HH:$mm:$ss';
}
