<?php
// controllers/CertificatesController.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/helpers.php';

class CertificatesController {

    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    // GET /certificates
    public function index(array $params): void {
        $auth   = requireAuth();
        $userId = $auth['user_id'];

        $stmt = $this->db->prepare(
            'SELECT * FROM certificates WHERE user_id = ? ORDER BY issued_at DESC'
        );
        $stmt->execute([$userId]);
        $certs = $stmt->fetchAll();

        foreach ($certs as &$c) {
            $c['is_downloaded'] = (bool) $c['is_downloaded'];
        }

        respond(true, $certs);
    }

    // PUT /certificates/{id}/download
    public function markDownloaded(array $params): void {
        $auth   = requireAuth();
        $userId = $auth['user_id'];
        $certId = $params['id'];

        $stmt = $this->db->prepare(
            'UPDATE certificates SET is_downloaded = 1
             WHERE id = ? AND user_id = ?'
        );
        $stmt->execute([$certId, $userId]);

        if ($stmt->rowCount() === 0) {
            respondError('Certificate not found.', 404);
        }

        respond(true, null, 'Certificate marked as downloaded.');
    }
}