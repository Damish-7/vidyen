// lib/models/preconf_model.dart
class PreConfModel {
  final int id;
  final String title;
  final String speaker;
  final String designation;
  final String description;
  final DateTime sessionDate;
  final String sessionTime;
  final String venue;
  final int maxParticipants;
  final int registeredCount;
  final bool isRegistered;

  PreConfModel({
    required this.id,
    required this.title,
    required this.speaker,
    required this.designation,
    required this.description,
    required this.sessionDate,
    required this.sessionTime,
    required this.venue,
    required this.maxParticipants,
    required this.registeredCount,
    required this.isRegistered,
  });

  bool get isFull => registeredCount >= maxParticipants && !isRegistered;

  factory PreConfModel.fromJson(Map<String, dynamic> j) => PreConfModel(
        id:               int.tryParse(j['id'].toString()) ?? 0,
        title:            j['title']       ?? '',
        speaker:          j['speaker']     ?? '',
        designation:      j['designation'] ?? '',
        description:      j['description'] ?? '',
        sessionDate:      DateTime.tryParse(j['session_date'] ?? '') ?? DateTime.now(),
        sessionTime:      j['session_time'] ?? '',
        venue:            j['venue']        ?? '',
        maxParticipants:  int.tryParse(j['max_participants'].toString()) ?? 0,
        registeredCount:  int.tryParse(j['registered_count'].toString()) ?? 0,
        isRegistered:     j['is_registered'] == true || j['is_registered'] == 1,
      );
}