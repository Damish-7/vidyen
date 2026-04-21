<?php
// controllers/AbstractsController.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/helpers.php';

class AbstractsController {

    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    // GET /abstracts
    public function index(array $params): void {
        $auth   = requireAuth();
        $status = $_GET['status'] ?? '';
        $category = $_GET['category'] ?? '';

        $sql  = 'SELECT a.*, u.name AS submitted_by_name
                 FROM abstracts a
                 LEFT JOIN users u ON a.submitted_by = u.id
                 WHERE 1=1';
        $args = [];

        if ($status && $status !== 'All') {
            $sql  .= ' AND a.status = ?';
            $args[] = strtolower($status);
        }
        if ($category && $category !== 'All') {
            $sql  .= ' AND a.category = ?';
            $args[] = $category;
        }

        $sql .= ' ORDER BY a.submitted_at DESC';

        $stmt = $this->db->prepare($sql);
        $stmt->execute($args);
        $abstracts = $stmt->fetchAll();

        // Stats
        $statsStmt = $this->db->query(
            'SELECT status, COUNT(*) as count FROM abstracts GROUP BY status'
        );
        $statsRaw = $statsStmt->fetchAll();
        $stats = ['total' => 0, 'accepted' => 0, 'pending' => 0, 'rejected' => 0];
        foreach ($statsRaw as $row) {
            $stats[$row['status']] = (int) $row['count'];
            $stats['total'] += (int) $row['count'];
        }

        respond(true, ['abstracts' => $abstracts, 'stats' => $stats]);
    }

    // GET /abstracts/{id}
    public function show(array $params): void {
        requireAuth();
        $stmt = $this->db->prepare(
            'SELECT a.*, u.name AS submitted_by_name
             FROM abstracts a LEFT JOIN users u ON a.submitted_by = u.id
             WHERE a.id = ? LIMIT 1'
        );
        $stmt->execute([$params['id']]);
        $abstract = $stmt->fetch();
        if (!$abstract) respondError('Abstract not found.', 404);
        respond(true, $abstract);
    }

    // POST /abstracts
    public function store(array $params): void {
        $auth = requireAuth();
        $body = getBody();

        $title            = sanitize($body['title'] ?? '');
        $authors          = sanitize($body['authors'] ?? '');
        $institution      = sanitize($body['institution'] ?? '');
        $category         = sanitize($body['category'] ?? '');
        $abstract_text    = sanitize($body['abstract_text'] ?? '');
        $presentation_type = sanitize($body['presentation_type'] ?? 'oral');

        if (!$title || !$authors || !$institution || !$category || !$abstract_text) {
            respondError('All fields are required.');
        }

        $stmt = $this->db->prepare(
            'INSERT INTO abstracts
             (title, authors, institution, category, abstract_text, presentation_type, status, submitted_by)
             VALUES (?, ?, ?, ?, ?, ?, "pending", ?)'
        );
        $stmt->execute([
            $title, $authors, $institution, $category,
            $abstract_text, $presentation_type, $auth['user_id']
        ]);

        respond(true, ['id' => $this->db->lastInsertId()],
            'Abstract submitted successfully.', 201);
    }
}
