<?php
// admin/config.php
session_start();

define('ADMIN_USER', 'admin');
define('ADMIN_PASS', 'vidyen@2024'); // Change this!

function requireAdminLogin(): void {
    if (empty($_SESSION['admin_logged_in'])) {
        header('Location: login.php');
        exit;
    }
}

function db(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO(
            'mysql:host=localhost;port=8889;dbname=vidyen_db;charset=utf8mb4',
            'root', 'root',
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
             PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
        );
    }
    return $pdo;
}

function flash(string $type, string $msg): void {
    $_SESSION['flash'] = ['type' => $type, 'msg' => $msg];
}

function getFlash(): ?array {
    $f = $_SESSION['flash'] ?? null;
    unset($_SESSION['flash']);
    return $f;
}

function generateCertCode(string $type): string {
    $prefix = strtoupper(substr($type, 0, 4));
    return 'VID-2025-' . $prefix . '-' . date('md') . '-' . strtoupper(substr(uniqid(), -5));
}