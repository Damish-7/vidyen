// lib/services/mock_data_seeder.dart
// Seeds Hive boxes with realistic mock data on first launch
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import '../models/hive_models/user_hive_model.dart';
import '../models/hive_models/abstract_hive_model.dart';
import '../models/hive_models/preconf_hive_model.dart';
import '../models/hive_models/workshop_hive_model.dart';
import '../models/hive_models/certificate_hive_model.dart';
import '../models/hive_models/settings_hive_model.dart';
import '../utils/hive_boxes.dart';

class MockDataSeeder {
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password + 'vidyen_salt_2024');
    return sha256.convert(bytes).toString();
  }

  /// Call once on first launch — checks flag before seeding
  static Future<void> seedIfEmpty() async {
    final usersBox = Hive.box<UserHiveModel>(HiveBoxes.users);
    if (usersBox.isNotEmpty) return; // already seeded

    await _seedUsers(usersBox);
    await _seedAbstracts();
    await _seedPreConf();
    await _seedWorkshops();
    await _seedCertificates();
    await _seedSettings();
  }

  // ── Users ──────────────────────────────────────────────────────────────────
  static Future<void> _seedUsers(Box<UserHiveModel> box) async {
    final users = [
      UserHiveModel(
        id: 'usr_001',
        name: 'Dr. Arjun Sharma',
        email: 'arjun.sharma@manipal.edu',
        username: 'arjunsharma',
        designation: 'Associate Professor',
        institution: 'Manipal Academy of Higher Education',
        passwordHash: _hashPassword('password123'),
      ),
      UserHiveModel(
        id: 'usr_002',
        name: 'Dr. Priya Nair',
        email: 'priya.nair@aims.edu',
        username: 'priyanair',
        designation: 'Senior Researcher',
        institution: 'AIIMS New Delhi',
        passwordHash: _hashPassword('password123'),
      ),
      UserHiveModel(
        id: 'usr_003',
        name: 'Prof. Rahul Menon',
        email: 'rahul.menon@iit.ac.in',
        username: 'rahulmenon',
        designation: 'Professor',
        institution: 'IIT Bombay',
        passwordHash: _hashPassword('password123'),
      ),
    ];
    for (final u in users) {
      await box.put(u.id, u);
    }
  }

  // ── Abstracts ──────────────────────────────────────────────────────────────
  static Future<void> _seedAbstracts() async {
    final box = Hive.box<AbstractHiveModel>(HiveBoxes.abstracts);
    final abstracts = [
      AbstractHiveModel(
        id: 'abs_001',
        title: 'Artificial Intelligence in Early Cancer Detection: A Systematic Review',
        authors: 'Sharma A., Nair P., Kumar R.',
        institution: 'Manipal Academy of Higher Education',
        category: 'Oncology',
        abstractText:
            'This systematic review evaluates the effectiveness of AI-based diagnostic tools in early-stage cancer detection across multiple organ systems. A meta-analysis of 42 randomized controlled trials showed AI models achieving sensitivity of 94.2% and specificity of 91.7%, outperforming traditional screening methods by 18.3%. The review highlights gaps in dataset diversity and regulatory considerations for clinical deployment.',
        status: 'accepted',
        presentationType: 'oral',
        submittedAt: DateTime.now().subtract(const Duration(days: 30)),
        submittedByUserId: 'usr_001',
      ),
      AbstractHiveModel(
        id: 'abs_002',
        title: 'Gut Microbiome Dysbiosis and Its Association with Type 2 Diabetes Mellitus',
        authors: 'Nair P., Shetty K., Verma S.',
        institution: 'AIIMS New Delhi',
        category: 'Endocrinology',
        abstractText:
            'A prospective cohort study of 340 patients examined microbiome composition changes preceding T2DM onset. Significant reduction in Faecalibacterium prausnitzii (p<0.001) and elevated Ruminococcus gnavus were observed 12 months prior to clinical diagnosis. These findings suggest microbiome profiling as a viable early biomarker for diabetes prediction.',
        status: 'accepted',
        presentationType: 'poster',
        submittedAt: DateTime.now().subtract(const Duration(days: 25)),
        submittedByUserId: 'usr_002',
      ),
      AbstractHiveModel(
        id: 'abs_003',
        title: 'Neuroplasticity-Based Rehabilitation in Post-Stroke Motor Recovery',
        authors: 'Menon R., Das A., Pillai S.',
        institution: 'IIT Bombay',
        category: 'Neurology',
        abstractText:
            'This randomized controlled trial assessed constraint-induced movement therapy (CIMT) combined with transcranial magnetic stimulation in 85 post-stroke patients. The intervention group showed 43% greater upper limb motor function improvement (Fugl-Meyer score) compared to standard rehabilitation at 6-month follow-up. Neuroimaging confirmed cortical reorganization patterns correlating with clinical improvement.',
        status: 'pending',
        presentationType: 'oral',
        submittedAt: DateTime.now().subtract(const Duration(days: 10)),
        submittedByUserId: 'usr_003',
      ),
      AbstractHiveModel(
        id: 'abs_004',
        title: 'Telemedicine Adoption in Rural India: Barriers and Facilitators',
        authors: 'Krishnan V., Patel M., Joshi A.',
        institution: 'CMC Vellore',
        category: 'Digital Health',
        abstractText:
            'A mixed-methods study exploring telemedicine utilization patterns across 12 rural districts in Karnataka and Maharashtra. Quantitative survey (n=1,200) and qualitative interviews (n=48) revealed connectivity infrastructure and digital literacy as primary barriers. Facilitator training programs increased adoption by 67% at 3-month follow-up.',
        status: 'accepted',
        presentationType: 'poster',
        submittedAt: DateTime.now().subtract(const Duration(days: 18)),
        submittedByUserId: null,
      ),
      AbstractHiveModel(
        id: 'abs_005',
        title: 'CRISPR-Cas9 Gene Editing in Sickle Cell Disease: Phase II Trial Results',
        authors: 'Reddy S., Iyer N., Bhatt P.',
        institution: 'NIMHANS Bangalore',
        category: 'Haematology',
        abstractText:
            'Phase II trial of autologous CRISPR-edited HSCs in 22 patients with severe sickle cell disease. At 18-month follow-up, 19/22 patients achieved transfusion independence with haemoglobin F levels >30%. No off-target editing events detected via whole-genome sequencing. Results suggest durable therapeutic benefit with an acceptable safety profile.',
        status: 'rejected',
        presentationType: 'oral',
        submittedAt: DateTime.now().subtract(const Duration(days: 45)),
        submittedByUserId: null,
      ),
    ];
    for (final a in abstracts) {
      await box.put(a.id, a);
    }
  }

  // ── Pre-Conference Sessions ────────────────────────────────────────────────
  static Future<void> _seedPreConf() async {
    final box = Hive.box<PreConfHiveModel>(HiveBoxes.preconf);
    final sessions = [
      PreConfHiveModel(
        id: 'pre_001',
        title: 'Research Methodology & Biostatistics Masterclass',
        speaker: 'Prof. Anitha Krishnamurthy',
        designation: 'Head of Biostatistics, AIIMS Delhi',
        description:
            'A comprehensive full-day masterclass covering study design, sample size calculation, statistical analysis using SPSS/R, and interpretation of research outputs. Ideal for residents and early-career researchers.',
        date: DateTime(2025, 3, 14),
        time: '09:00 AM – 05:00 PM',
        venue: 'Conference Hall A, Ground Floor',
        maxParticipants: 60,
        registeredCount: 54,
        isRegistered: true,
      ),
      PreConfHiveModel(
        id: 'pre_002',
        title: 'Grant Writing for Medical Research',
        speaker: 'Dr. Suresh Babu',
        designation: 'Principal Investigator, ICMR',
        description:
            'Learn how to structure compelling research proposals, navigate funding agency requirements, and write budgets that get approved. Real grant reviews and feedback sessions included.',
        date: DateTime(2025, 3, 14),
        time: '09:00 AM – 01:00 PM',
        venue: 'Seminar Room B, First Floor',
        maxParticipants: 40,
        registeredCount: 40,
        isRegistered: false,
      ),
      PreConfHiveModel(
        id: 'pre_003',
        title: 'Systematic Review & Meta-Analysis Workshop',
        speaker: 'Dr. Meena Rajan',
        designation: 'Cochrane Review Author, CMC Vellore',
        description:
            'Step-by-step guidance on conducting systematic reviews using PRISMA guidelines, RevMan software for meta-analysis, heterogeneity assessment, and publication bias detection.',
        date: DateTime(2025, 3, 14),
        time: '02:00 PM – 06:00 PM',
        venue: 'Seminar Room B, First Floor',
        maxParticipants: 35,
        registeredCount: 22,
        isRegistered: false,
      ),
    ];
    for (final s in sessions) {
      await box.put(s.id, s);
    }
  }

  // ── Workshops ──────────────────────────────────────────────────────────────
  static Future<void> _seedWorkshops() async {
    final box = Hive.box<WorkshopHiveModel>(HiveBoxes.workshops);
    final workshops = [
      WorkshopHiveModel(
        id: 'ws_001',
        title: 'Advanced Laparoscopic Surgical Techniques',
        facilitator: 'Dr. Rajesh Pillai',
        designation: 'Senior Surgeon, Amrita Institute',
        description:
            'Hands-on simulation workshop using box trainers and cadaveric models. Participants will practice intracorporeal suturing, knot tying, and laparoscopic cholecystectomy steps under expert supervision.',
        date: DateTime(2025, 3, 15),
        time: '08:00 AM',
        duration: '4 hours',
        venue: 'Simulation Lab, Second Floor',
        maxParticipants: 20,
        registeredCount: 18,
        isRegistered: true,
        topics: [
          'Box trainer exercises',
          'Intracorporeal suturing',
          'Knot tying techniques',
          'Laparoscopic cholecystectomy steps',
          'Complication management',
        ],
      ),
      WorkshopHiveModel(
        id: 'ws_002',
        title: 'Point-of-Care Ultrasound (POCUS) for Clinicians',
        facilitator: 'Dr. Divya Gopalan',
        designation: 'Emergency Medicine Specialist, KMC Manipal',
        description:
            'Introductory and intermediate POCUS training covering FAST exam, lung ultrasound, cardiac windows, and vascular access guidance. Each participant gets dedicated probe time with real-time feedback.',
        date: DateTime(2025, 3, 15),
        time: '09:00 AM',
        duration: '3 hours',
        venue: 'Skills Lab, Ground Floor',
        maxParticipants: 24,
        registeredCount: 16,
        isRegistered: false,
        topics: [
          'FAST examination protocol',
          'Lung ultrasound basics',
          'Cardiac windows',
          'Vascular access guidance',
          'Image optimization',
        ],
      ),
      WorkshopHiveModel(
        id: 'ws_003',
        title: 'Medical Writing & Journal Publication',
        facilitator: 'Dr. Kavitha Srinivasan',
        designation: 'Associate Editor, Indian Journal of Medical Research',
        description:
            'A practical workshop on writing original research articles, case reports, and review papers. Topics include journal selection, peer review process, responding to reviewers, and avoiding common rejection pitfalls.',
        date: DateTime(2025, 3, 15),
        time: '02:00 PM',
        duration: '3 hours',
        venue: 'Conference Hall B, Ground Floor',
        maxParticipants: 50,
        registeredCount: 31,
        isRegistered: false,
        topics: [
          'Structuring your manuscript (IMRaD)',
          'Choosing the right journal',
          'Understanding the peer review process',
          'Responding to reviewer comments',
          'Ethical considerations in publication',
        ],
      ),
    ];
    for (final w in workshops) {
      await box.put(w.id, w);
    }
  }

  // ── Certificates ───────────────────────────────────────────────────────────
  static Future<void> _seedCertificates() async {
    final box = Hive.box<CertificateHiveModel>(HiveBoxes.certificates);
    final certs = [
      CertificateHiveModel(
        id: 'cert_001',
        userId: 'usr_001',
        type: 'participation',
        title: 'Certificate of Participation',
        eventName: 'VIDYEN Annual Conference 2025',
        issuedAt: DateTime(2025, 3, 17),
        certificateCode: 'VID-2025-PART-0317-001',
        isDownloaded: false,
      ),
      CertificateHiveModel(
        id: 'cert_002',
        userId: 'usr_001',
        type: 'presenter',
        title: 'Certificate of Presentation',
        eventName: 'VIDYEN Annual Conference 2025',
        issuedAt: DateTime(2025, 3, 16),
        certificateCode: 'VID-2025-PRES-0316-001',
        isDownloaded: true,
      ),
      CertificateHiveModel(
        id: 'cert_003',
        userId: 'usr_001',
        type: 'workshop',
        title: 'Workshop Completion Certificate',
        eventName: 'Advanced Laparoscopic Surgical Techniques',
        issuedAt: DateTime(2025, 3, 15),
        certificateCode: 'VID-2025-WS-0315-001',
        isDownloaded: false,
      ),
    ];
    for (final c in certs) {
      await box.put(c.id, c);
    }
  }

  // ── Settings ───────────────────────────────────────────────────────────────
  static Future<void> _seedSettings() async {
    final box = Hive.box<SettingsHiveModel>(HiveBoxes.settings);
    if (box.get('app_settings') == null) {
      await box.put(
        'app_settings',
        SettingsHiveModel(lastSyncAt: DateTime.now()),
      );
    }
  }
}