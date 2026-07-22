/// A single practice checklist entry on the home practice panel.
class PracticeItem {
  final String name;
  bool done;
  bool sent;

  PracticeItem(
    this.name, {
    this.done = false,
    this.sent = false,
  });
}
