<?php
// admin/layout.php  — include this at the top of every admin page
// Usage: include 'layout.php'; with $page and $title already set
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>VIDYEN Admin — <?= htmlspecialchars($title ?? 'Dashboard') ?></title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="layout">

<!-- Sidebar -->
<aside class="sidebar">
  <div class="sidebar-logo">
    <h1>VIDYEN</h1>
    <p>ADMIN PANEL</p>
  </div>
  <nav class="nav">
    <a href="index.php"        class="<?= ($page??'')=='dashboard'   ? 'active':'' ?>">
      <span class="ico">🏠</span> Dashboard</a>
    <a href="users.php"        class="<?= ($page??'')=='users'       ? 'active':'' ?>">
      <span class="ico">👥</span> Users</a>
    <a href="abstracts.php"    class="<?= ($page??'')=='abstracts'   ? 'active':'' ?>">
      <span class="ico">📄</span> Abstracts</a>
    <a href="preconf.php"      class="<?= ($page??'')=='preconf'     ? 'active':'' ?>">
      <span class="ico">📅</span> Pre-Conference</a>
    <a href="workshops.php"    class="<?= ($page??'')=='workshops'   ? 'active':'' ?>">
      <span class="ico">🤝</span> Workshops</a>
    <a href="certificates.php" class="<?= ($page??'')=='certificates'? 'active':'' ?>">
      <span class="ico">🏆</span> Certificates</a>
  </nav>
  <div class="sidebar-footer">
    <a href="logout.php">⎋ Logout</a>
  </div>
</aside>

<!-- Main content -->
<main class="main">
<?php $flash = getFlash(); if ($flash): ?>
<div class="flash flash-<?= $flash['type'] ?>">
  <?= $flash['type']==='success' ? '✓' : '✕' ?>
  <?= htmlspecialchars($flash['msg']) ?>
</div>
<?php endif; ?>
