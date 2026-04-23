<?php
// admin/login.php — standalone, does NOT include config.php to avoid double session_start
session_start();

// If already logged in, go straight to dashboard
if (!empty($_SESSION['admin_logged_in'])) {
    header('Location: index.php');
    exit;
}

define('ADMIN_USER', 'admin');
define('ADMIN_PASS', 'vidyen@2024');

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';

    if ($username === ADMIN_USER && $password === ADMIN_PASS) {
        $_SESSION['admin_logged_in'] = true;
        $_SESSION['admin_user']      = $username;
        // Use relative redirect — works on all MAMP setups
        header('Location: index.php');
        exit;
    }
    $error = 'Invalid username or password. Try: admin / vidyen@2024';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>VIDYEN Admin — Login</title>
<link rel="stylesheet" href="assets/style.css">
<style>
  body { display:flex; align-items:center; justify-content:center; min-height:100vh; }
  .box {
    background:var(--card); border:1px solid var(--border);
    border-radius:20px; padding:44px 40px; width:100%; max-width:400px;
  }
  .logo { text-align:center; margin-bottom:32px; }
  .logo h1 {
    font-size:32px; font-weight:800; letter-spacing:7px;
    background:linear-gradient(135deg,var(--teal),var(--blue));
    -webkit-background-clip:text; -webkit-text-fill-color:transparent;
  }
  .logo p { color:var(--dim); font-size:11px; letter-spacing:2.5px; margin-top:5px; }
  h2 { font-size:18px; font-weight:700; margin-bottom:22px; }
  .fg { margin-bottom:16px; display:flex; flex-direction:column; gap:6px; }
  .er {
    background:rgba(255,77,109,.1); border:1px solid rgba(255,77,109,.3);
    color:var(--red); border-radius:10px; padding:11px 14px;
    font-size:13px; margin-bottom:14px;
  }
  .sub {
    width:100%; background:linear-gradient(135deg,var(--teal),var(--blue));
    color:#060E1E; border:none; border-radius:10px; padding:13px;
    font-size:15px; font-weight:700; cursor:pointer; margin-top:6px;
    transition:opacity .15s;
  }
  .sub:hover { opacity:.88; }
  .hint { text-align:center; color:var(--dim); font-size:12px; margin-top:18px; }
  .hint code { color:var(--teal); }
</style>
</head>
<body>
<div class="box">
  <div class="logo">
    <h1>VIDYEN</h1>
    <p>ADMIN PANEL</p>
  </div>
  <h2>Sign In</h2>

  <?php if ($error): ?>
    <div class="er">✕ <?= htmlspecialchars($error) ?></div>
  <?php endif; ?>

  <form method="POST" action="login.php">
    <div class="fg">
      <label>Username</label>
      <input type="text" name="username"
             value="<?= htmlspecialchars($_POST['username'] ?? '') ?>"
             placeholder="admin" required autofocus>
    </div>
    <div class="fg">
      <label>Password</label>
      <input type="password" name="password" placeholder="••••••••" required>
    </div>
    <button type="submit" class="sub">Sign In →</button>
  </form>

  <!--<p class="hint">Default: <code>admin</code> / <code>vidyen@2024</code></p>-->
</div>
</body>
</html>