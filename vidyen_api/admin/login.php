<?php
// admin/login.php
session_start();
define('ADMIN_USER', 'admin');
define('ADMIN_PASS', 'vidyen@2024');

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if ($_POST['username'] === ADMIN_USER && $_POST['password'] === ADMIN_PASS) {
        $_SESSION['admin_logged_in'] = true;
        header('Location: index.php');
        exit;
    }
    $error = 'Invalid username or password.';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>VIDYEN Admin Login</title>
<link rel="stylesheet" href="assets/style.css">
<style>
  .login-wrap { min-height: 100vh; display: flex;
    align-items: center; justify-content: center; }
  .login-box  { background: var(--card); border: 1px solid var(--border);
    border-radius: 20px; padding: 40px; width: 100%; max-width: 400px; }
  .login-logo { text-align: center; margin-bottom: 28px; }
  .login-logo h1 { font-size: 30px; font-weight: 800; letter-spacing: 6px;
    background: linear-gradient(135deg,var(--teal),var(--blue));
    -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
  .login-logo p { color: var(--dim); font-size: 12px; letter-spacing: 2px;
    margin-top: 4px; }
  .login-box h2 { font-size: 18px; font-weight: 700; margin-bottom: 20px; }
  .form-group { margin-bottom: 16px; }
  .btn-full { width: 100%; justify-content: center; padding: 13px; font-size: 15px; }
  .error { color: var(--red); font-size: 13px; margin-bottom: 14px;
    background: rgba(255,77,109,.1); border: 1px solid rgba(255,77,109,.3);
    padding: 10px 14px; border-radius: 8px; }
</style>
</head>
<body>
<div class="login-wrap">
  <div class="login-box">
    <div class="login-logo">
      <h1>VIDYEN</h1>
      <p>ADMIN PANEL</p>
    </div>
    <h2>Sign In</h2>
    <?php if ($error): ?>
      <div class="error">✕ <?= htmlspecialchars($error) ?></div>
    <?php endif; ?>
    <form method="POST">
      <div class="form-group">
        <label>Username</label>
        <input type="text" name="username" placeholder="admin" required autofocus>
      </div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" placeholder="••••••••" required>
      </div>
      <button type="submit" class="btn btn-teal btn-full" style="margin-top:8px">
        Sign In →
      </button>
    </form>
  </div>
</div>
</body>
</html>
