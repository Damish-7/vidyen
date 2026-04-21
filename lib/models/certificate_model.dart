// lib/models/certificate_model.dart
class CertificateModel {
  final int id;
  final int userId;
  final String type;
  final String title;
  final String eventName;
  final DateTime issuedAt;
  final String certificateCode;
  final bool isDownloaded;

  CertificateModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.eventName,
    required this.issuedAt,
    required this.certificateCode,
    required this.isDownloaded,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> j) => CertificateModel(
        id:              int.tryParse(j['id'].toString()) ?? 0,
        userId:          int.tryParse(j['user_id'].toString()) ?? 0,
        type:            j['type']             ?? '',
        title:           j['title']            ?? '',
        eventName:       j['event_name']       ?? '',
        issuedAt:        DateTime.tryParse(j['issued_at'] ?? '') ?? DateTime.now(),
        certificateCode: j['certificate_code'] ?? '',
        isDownloaded:    j['is_downloaded'] == true || j['is_downloaded'] == 1,
      );
}