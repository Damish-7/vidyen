// lib/models/workshop_model.dart
class WorkshopModel {
  final int id;
  final String title;
  final String facilitator;
  final String designation;
  final String description;
  final DateTime workshopDate;
  final String workshopTime;
  final String duration;
  final String venue;
  final List<String> topics;
  final int maxParticipants;
  final int registeredCount;
  final bool isRegistered;

  WorkshopModel({
    required this.id,
    required this.title,
    required this.facilitator,
    required this.designation,
    required this.description,
    required this.workshopDate,
    required this.workshopTime,
    required this.duration,
    required this.venue,
    required this.topics,
    required this.maxParticipants,
    required this.registeredCount,
    required this.isRegistered,
  });

  bool get isFull => registeredCount >= maxParticipants && !isRegistered;

  factory WorkshopModel.fromJson(Map<String, dynamic> j) {
    List<String> topics = [];
    if (j['topics'] is List) {
      topics = (j['topics'] as List).map((e) => e.toString()).toList();
    }
    return WorkshopModel(
      id:              int.tryParse(j['id'].toString()) ?? 0,
      title:           j['title']         ?? '',
      facilitator:     j['facilitator']   ?? '',
      designation:     j['designation']   ?? '',
      description:     j['description']   ?? '',
      workshopDate:    DateTime.tryParse(j['workshop_date'] ?? '') ?? DateTime.now(),
      workshopTime:    j['workshop_time'] ?? '',
      duration:        j['duration']      ?? '',
      venue:           j['venue']         ?? '',
      topics:          topics,
      maxParticipants: int.tryParse(j['max_participants'].toString()) ?? 0,
      registeredCount: int.tryParse(j['registered_count'].toString()) ?? 0,
      isRegistered:    j['is_registered'] == true || j['is_registered'] == 1,
    );
  }
}