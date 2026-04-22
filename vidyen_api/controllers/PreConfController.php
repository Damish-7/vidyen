<?php
// controllers/PreConfController.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/helpers.php';

class PreConfController {

    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    // GET /preconf
    public function index(array $params): void {
        $auth = requireAuth();
        $userId = $auth['user_id'];

        $stmt = $this->db->prepare(
            'SELECT s.*,
                    (SELECT COUNT(*) FROM preconf_registrations WHERE session_id = s.id) AS registered_count,
                    EXISTS(SELECT 1 FROM preconf_registrations WHERE session_id = s.id AND user_id = ?) AS is_registered
             FROM preconf_sessions s
             ORDER BY s.session_date ASC, s.session_time ASC'
        );
        $stmt->execute([$userId]);
        $sessions = $stmt->fetchAll();

        foreach ($sessions as &$s) {
            $s['is_registered']   = (bool) $s['is_registered'];
            $s['registered_count'] = (int) $s['registered_count'];
            $s['max_participants'] = (int) $s['max_participants'];
        }

        respond(true, $sessions);
    }

    // POST /preconf/{id}/register
    public function register(array $params): void {
        $auth   = requireAuth();
        $userId = $auth['user_id'];
        $sessionId = $params['id'];

        // Check session exists
        $stmt = $this->db->prepare('SELECT * FROM preconf_sessions WHERE id = ? LIMIT 1');
        $stmt->execute([$sessionId]);
        $session = $stmt->fetch();
        if (!$session) respondError('Session not found.', 404);

        // Check capacity
        $countStmt = $this->db->prepare(
            'SELECT COUNT(*) FROM preconf_registrations WHERE session_id = ?'
        );
        $countStmt->execute([$sessionId]);
        $count = (int) $countStmt->fetchColumn();

        if ($count >= $session['max_participants']) {
            respondError('This session is full.');
        }

        // Check already registered
        $check = $this->db->prepare(
            'SELECT id FROM preconf_registrations WHERE session_id = ? AND user_id = ?'
        );
        $check->execute([$sessionId, $userId]);
        if ($check->fetch()) respondError('You are already registered for this session.');

        $stmt = $this->db->prepare(
            'INSERT INTO preconf_registrations (session_id, user_id) VALUES (?, ?)'
        );
        $stmt->execute([$sessionId, $userId]);

        respond(true, null, 'Registered successfully.');
    }

    // DELETE /preconf/{id}/register
    public function unregister(array $params): void {
        $auth   = requireAuth();
        $userId = $auth['user_id'];
        $sessionId = $params['id'];

        $stmt = $this->db->prepare(
            'DELETE FROM preconf_registrations WHERE session_id = ? AND user_id = ?'
        );
        $stmt->execute([$sessionId, $userId]);

        if ($stmt->rowCount() === 0) {
            respondError('Registration not found.');
        }

        respond(true, null, 'Registration cancelled.');
    }

    // POST /preconf — Create new session
    public function store(array $params): void {
        requireAuth(); // any logged-in user can propose a session

        $body = getBody();

        $title           = sanitize($body['title']           ?? '');
        $speaker         = sanitize($body['speaker']         ?? '');
        $designation     = sanitize($body['designation']     ?? '');
        $description     = sanitize($body['description']     ?? '');
        $session_date    = sanitize($body['session_date']    ?? '');
        $session_time    = sanitize($body['session_time']    ?? '');
        $venue           = sanitize($body['venue']           ?? '');
        $max_participants = (int)($body['max_participants']  ?? 50);

        if (!$title || !$speaker || !$session_date || !$session_time || !$venue) {
            respondError('Title, speaker, date, time and venue are required.');
        }

        // Validate date format
        if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $session_date)) {
            respondError('Invalid date format. Use YYYY-MM-DD.');
        }

        if ($max_participants < 1 || $max_participants > 500) {
            $max_participants = 50;
        }

        $stmt = $this->db->prepare(
            'INSERT INTO preconf_sessions
             (title, speaker, designation, description, session_date, session_time, venue, max_participants)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([
            $title, $speaker, $designation, $description,
            $session_date, $session_time, $venue, $max_participants
        ]);

        respond(true, ['id' => $this->db->lastInsertId()],
            'Session created successfully.', 201);
    }
}
