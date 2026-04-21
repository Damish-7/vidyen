<?php
// controllers/HomeController.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/helpers.php';

class HomeController {

    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    // GET /home/stats
    public function stats(array $params): void {
        $auth   = requireAuth();
        $userId = $auth['user_id'];

        // Accepted abstracts (all)
        $absStmt = $this->db->query(
            "SELECT COUNT(*) FROM abstracts WHERE status = 'accepted'"
        );
        $acceptedAbstracts = (int) $absStmt->fetchColumn();

        // Pre-conf sessions user registered for
        $preStmt = $this->db->prepare(
            'SELECT COUNT(*) FROM preconf_registrations WHERE user_id = ?'
        );
        $preStmt->execute([$userId]);
        $preconfRegistered = (int) $preStmt->fetchColumn();

        // Workshops user registered for
        $wsStmt = $this->db->prepare(
            'SELECT COUNT(*) FROM workshop_registrations WHERE user_id = ?'
        );
        $wsStmt->execute([$userId]);
        $workshopsBooked = (int) $wsStmt->fetchColumn();

        // Certificates count
        $certStmt = $this->db->prepare(
            'SELECT COUNT(*) FROM certificates WHERE user_id = ?'
        );
        $certStmt->execute([$userId]);
        $certCount = (int) $certStmt->fetchColumn();

        respond(true, [
            'accepted_abstracts'  => $acceptedAbstracts,
            'preconf_registered'  => $preconfRegistered,
            'workshops_booked'    => $workshopsBooked,
            'certificates'        => $certCount,
        ]);
    }
}