<?php
// utils/helpers.php

function setCorsHeaders(): void {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
    header('Content-Type: application/json; charset=UTF-8');
    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(200);
        exit;
    }
}

function respond(bool $success, $data = null, string $message = '', int $code = 200): void {
    http_response_code($code);
    $response = ['success' => $success, 'message' => $message];
    if ($data !== null) $response['data'] = $data;
    echo json_encode($response);
    exit;
}

function respondError(string $message, int $code = 400): void {
    respond(false, null, $message, $code);
}

function getBody(): array {
    $raw = file_get_contents('php://input');
    $data = json_decode($raw, true);
    return is_array($data) ? $data : [];
}

function sanitize(string $value): string {
    return htmlspecialchars(strip_tags(trim($value)));
}

function generateToken(int $userId): string {
    $payload = base64_encode(json_encode([
        'user_id' => $userId,
        'issued'  => time(),
        'exp'     => time() + (60 * 60 * 24 * 7), // 7 days
    ]));
    $secret = 'VIDYEN_SECRET_KEY_2024';
    $sig = hash_hmac('sha256', $payload, $secret);
    return $payload . '.' . $sig;
}

function verifyToken(string $token): ?array {
    $secret = 'VIDYEN_SECRET_KEY_2024';
    $parts  = explode('.', $token);
    if (count($parts) !== 2) return null;
    [$payload, $sig] = $parts;
    if (hash_hmac('sha256', $payload, $secret) !== $sig) return null;
    $data = json_decode(base64_decode($payload), true);
    if (!$data || $data['exp'] < time()) return null;
    return $data;
}

function requireAuth(): array {
    $headers = getallheaders();
    $auth    = $headers['Authorization'] ?? $headers['authorization'] ?? '';
    if (!str_starts_with($auth, 'Bearer ')) {
        respondError('Unauthorized', 401);
    }
    $token = substr($auth, 7);
    $data  = verifyToken($token);
    if (!$data) respondError('Invalid or expired token', 401);
    return $data;
}
