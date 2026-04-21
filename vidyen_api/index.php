<?php
// index.php — main router
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/utils/helpers.php';

setCorsHeaders();

$method = $_SERVER['REQUEST_METHOD'];
$uri    = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Strip base path: /vidyen_api/
$base = '/vidyen_api';
if (str_starts_with($uri, $base)) {
    $uri = substr($uri, strlen($base));
}
$uri = rtrim($uri, '/') ?: '/';

// ── Route table ────────────────────────────────────────────────────────────
$routes = [
    'POST /auth/register'       => 'AuthController@register',
    'POST /auth/login'          => 'AuthController@login',
    'GET /auth/me'              => 'AuthController@me',

    'GET /abstracts'            => 'AbstractsController@index',
    'POST /abstracts'           => 'AbstractsController@store',
    'GET /abstracts/{id}'       => 'AbstractsController@show',

    'GET /preconf'              => 'PreConfController@index',
    'POST /preconf/{id}/register'   => 'PreConfController@register',
    'DELETE /preconf/{id}/register' => 'PreConfController@unregister',

    'GET /workshops'            => 'WorkshopController@index',
    'POST /workshops/{id}/register'   => 'WorkshopController@register',
    'DELETE /workshops/{id}/register' => 'WorkshopController@unregister',

    'GET /certificates'         => 'CertificatesController@index',
    'PUT /certificates/{id}/download' => 'CertificatesController@markDownloaded',

    'GET /home/stats'           => 'HomeController@stats',
];

// ── Route matching ─────────────────────────────────────────────────────────
$params = [];
$matched = false;

foreach ($routes as $route => $handler) {
    [$routeMethod, $routePath] = explode(' ', $route, 2);
    if ($routeMethod !== $method) continue;

    // Convert {id} to regex
    $pattern = preg_replace('/\{(\w+)\}/', '(?P<$1>[^/]+)', $routePath);
    $pattern = '#^' . $pattern . '$#';

    if (preg_match($pattern, $uri, $matches)) {
        foreach ($matches as $k => $v) {
            if (!is_int($k)) $params[$k] = $v;
        }
        [$controllerName, $action] = explode('@', $handler);
        require_once __DIR__ . '/controllers/' . $controllerName . '.php';
        $controller = new $controllerName();
        $controller->$action($params);
        $matched = true;
        break;
    }
}

if (!$matched) {
    respondError('Route not found', 404);
}
