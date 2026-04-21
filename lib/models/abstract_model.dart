// lib/models/abstract_model.dart
class AbstractModel {
  final int id;
  final String title;
  final String authors;
  final String institution;
  final String category;
  final String abstractText;
  final String presentationType;
  final String status;
  final int? submittedBy;
  final String? submittedByName;
  final DateTime submittedAt;

  AbstractModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.institution,
    required this.category,
    required this.abstractText,
    required this.presentationType,
    required this.status,
    this.submittedBy,
    this.submittedByName,
    required this.submittedAt,
  });

  factory AbstractModel.fromJson(Map<String, dynamic> j) => AbstractModel(
        id:               int.tryParse(j['id'].toString()) ?? 0,
        title:            j['title']             ?? '',
        authors:          j['authors']           ?? '',
        institution:      j['institution']       ?? '',
        category:         j['category']          ?? '',
        abstractText:     j['abstract_text']     ?? '',
        presentationType: j['presentation_type'] ?? 'oral',
        status:           j['status']            ?? 'pending',
        submittedBy:      j['submitted_by'] != null ? int.tryParse(j['submitted_by'].toString()) : null,
        submittedByName:  j['submitted_by_name'],
        submittedAt:      DateTime.tryParse(j['submitted_at'] ?? '') ?? DateTime.now(),
      );
}