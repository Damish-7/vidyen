<?php
// controllers/AuthController.php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/helpers.php';

class AuthController {

    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    // POST /auth/register
    public function register(array $params): void {
        $body = getBody();

        $name        = sanitize($body['name'] ?? '');
        $email       = strtolower(trim($body['email'] ?? ''));
        $username    = strtolower(trim($body['username'] ?? ''));
        $password    = $body['password'] ?? '';
        $designation = sanitize($body['designation'] ?? '');
        $institution = sanitize($body['institution'] ?? '');

        if (!$name || !$email || !$username || !$password) {
            respondError('Name, email, username and password are required.');
        }
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            respondError('Invalid email address.');
        }
        if (strlen($password) < 6) {
            respondError('Password must be at least 6 characters.');
        }

        // Check duplicates
        $stmt = $this->db->prepare('SELECT id FROM users WHERE email = ? OR username = ? LIMIT 1');
        $stmt->execute([$email, $username]);
        $existing = $stmt->fetch();
        if ($existing) {
            respondError('An account with this email or username already exists.');
        }

        $hash = password_hash($password, PASSWORD_BCRYPT);
        $stmt = $this->db->prepare(
            'INSERT INTO users (name, email, username, password_hash, designation, institution)
             VALUES (?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([$name, $email, $username, $hash, $designation, $institution]);

        respond(true, null, 'Account created successfully.', 201);
    }

    // POST /auth/login
    public function login(array $params): void {
        $body       = getBody();
        $identifier = strtolower(trim($body['identifier'] ?? ''));
        $password   = $body['password'] ?? '';

        if (!$identifier || !$password) {
            respondError('Email/username and password are required.');
        }

        $stmt = $this->db->prepare(
            'SELECT * FROM users WHERE email = ? OR username = ? LIMIT 1'
        );
        $stmt->execute([$identifier, $identifier]);
        $user = $stmt->fetch();

        if (!$user || !password_verify($password, $user['password_hash'])) {
            respondError('Invalid credentials. Please try again.', 401);
        }

        $token = generateToken($user['id']);

        unset($user['password_hash']);
        respond(true, ['token' => $token, 'user' => $user], 'Login successful.');
    }

    // GET /auth/me
    public function me(array $params): void {
        $auth = requireAuth();

        $stmt = $this->db->prepare(
            'SELECT id, name, email, username, designation, institution, avatar, created_at
             FROM users WHERE id = ? LIMIT 1'
        );
        $stmt->execute([$auth['user_id']]);
        $user = $stmt->fetch();

        if (!$user) respondError('User not found.', 404);

        respond(true, $user);
    }
}