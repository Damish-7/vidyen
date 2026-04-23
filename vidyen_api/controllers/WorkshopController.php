<?php
// controllers/WorkshopController.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/helpers.php';

class WorkshopController {

    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    // GET /workshops
    public function index(array $params): void {
        $auth   = requireAuth();
        $userId = $auth['user_id'];

        $stmt = $this->db->prepare(
            'SELECT w.*,
                    (SELECT COUNT(*) FROM workshop_registrations WHERE workshop_id = w.id) AS registered_count,
                    EXISTS(SELECT 1 FROM workshop_registrations WHERE workshop_id = w.id AND user_id = ?) AS is_registered
             FROM workshops w
             ORDER BY w.workshop_date ASC, w.workshop_time ASC'
        );
        $stmt->execute([$userId]);
        $workshops = $stmt->fetchAll();

        foreach ($workshops as &$w) {
            $w['is_registered']    = (bool) $w['is_registered'];
            $w['registered_count'] = (int)  $w['registered_count'];
            $w['max_participants'] = (int)  $w['max_participants'];
            $w['topics'] = json_decode($w['topics'] ?? '[]', true);
        }

        respond(true, $workshops);
    }

    // POST /workshops/{id}/register
    public function register(array $params): void {
        $auth       = requireAuth();
        $userId     = $auth['user_id'];
        $workshopId = $params['id'];

        $stmt = $this->db->prepare('SELECT * FROM workshops WHERE id = ? LIMIT 1');
        $stmt->execute([$workshopId]);
        $workshop = $stmt->fetch();
        if (!$workshop) respondError('Workshop not found.', 404);

        $countStmt = $this->db->prepare(
            'SELECT COUNT(*) FROM workshop_registrations WHERE workshop_id = ?'
        );
        $countStmt->execute([$workshopId]);
        $count = (int) $countStmt->fetchColumn();

        if ($count >= $workshop['max_participants']) {
            respondError('This workshop is full.');
        }

        $check = $this->db->prepare(
            'SELECT id FROM workshop_registrations WHERE workshop_id = ? AND user_id = ?'
        );
        $check->execute([$workshopId, $userId]);
        if ($check->fetch()) respondError('You are already registered for this workshop.');

        $stmt = $this->db->prepare(
            'INSERT INTO workshop_registrations (workshop_id, user_id) VALUES (?, ?)'
        );
        $stmt->execute([$workshopId, $userId]);

        respond(true, null, 'Workshop seat booked successfully.');
    }

    // DELETE /workshops/{id}/register
    public function unregister(array $params): void {
        $auth       = requireAuth();
        $userId     = $auth['user_id'];
        $workshopId = $params['id'];

        $stmt = $this->db->prepare(
            'DELETE FROM workshop_registrations WHERE workshop_id = ? AND user_id = ?'
        );
        $stmt->execute([$workshopId, $userId]);

        if ($stmt->rowCount() === 0) respondError('Registration not found.');

        respond(true, null, 'Registration cancelled.');
    }

    // POST /workshops — Create new workshop
    public function store(array $params): void {
        requireAuth();

        $body = getBody();

        $title           = sanitize($body['title']           ?? '');
        $facilitator     = sanitize($body['facilitator']     ?? '');
        $designation     = sanitize($body['designation']     ?? '');
        $description     = sanitize($body['description']     ?? '');
        $workshop_date   = sanitize($body['workshop_date']   ?? '');
        $workshop_time   = sanitize($body['workshop_time']   ?? '');
        $duration        = sanitize($body['duration']        ?? '');
        $venue           = sanitize($body['venue']           ?? '');
        $max_participants = (int)($body['max_participants']  ?? 30);
        $topics          = $body['topics'] ?? [];

        if (!$title || !$facilitator || !$workshop_date || !$workshop_time || !$venue) {
            respondError('Title, facilitator, date, time and venue are required.');
        }

        if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $workshop_date)) {
            respondError('Invalid date format. Use YYYY-MM-DD.');
        }

        if ($max_participants < 1 || $max_participants > 500) {
            $max_participants = 30;
        }

        // Encode topics array as JSON
        $topicsJson = json_encode(
            is_array($topics) ? array_values($topics) : []
        );

        $stmt = $this->db->prepare(
            'INSERT INTO workshops
             (title, facilitator, designation, description,
              workshop_date, workshop_time, duration, venue,
              topics, max_participants)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([
            $title, $facilitator, $designation, $description,
            $workshop_date, $workshop_time, $duration, $venue,
            $topicsJson, $max_participants,
        ]);

        respond(true, ['id' => $this->db->lastInsertId()],
            'Workshop created successfully.', 201);
    }
}