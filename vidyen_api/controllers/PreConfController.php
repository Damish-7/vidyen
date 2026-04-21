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
}
