<?php
require 'config.php';
requireAdminLogin();
$page = 'dashboard'; $title = 'Dashboard';
$db = db();

$users       = $db->query('SELECT COUNT(*) FROM users')->fetchColumn();
$abstracts   = $db->query('SELECT COUNT(*) FROM abstracts')->fetchColumn();
$accepted    = $db->query("SELECT COUNT(*) FROM abstracts WHERE status='accepted'")->fetchColumn();
$pending     = $db->query("SELECT COUNT(*) FROM abstracts WHERE status='pending'")->fetchColumn();
$preconf_reg = $db->query('SELECT COUNT(*) FROM preconf_registrations')->fetchColumn();
$ws_reg      = $db->query('SELECT COUNT(*) FROM workshop_registrations')->fetchColumn();
$certs       = $db->query('SELECT COUNT(*) FROM certificates')->fetchColumn();

// Recent abstracts
$recent = $db->query(
    'SELECT a.title, a.status, u.name AS author, a.submitted_at
     FROM abstracts a LEFT JOIN users u ON a.submitted_by = u.id
     ORDER BY a.submitted_at DESC LIMIT 6'
)->fetchAll();

include 'layout.php';
?>

<div class="page-header">
  <h2>Dashboard</h2>
  <p>Overview of VIDYEN Conference Portal activity</p>
</div>

<div class="stats">
  <div class="stat-card">
    <div class="label">👥 Total Users</div>
    <div class="value" style="color:var(--teal)"><?= $users ?></div>
    <div class="sub">Registered accounts</div>
  </div>
  <div class="stat-card">
    <div class="label">📄 Abstracts</div>
    <div class="value" style="color:var(--blue)"><?= $abstracts ?></div>
    <div class="sub"><?= $accepted ?> accepted · <?= $pending ?> pending</div>
  </div>
  <div class="stat-card">
    <div class="label">📅 Pre-Conf Registrations</div>
    <div class="value" style="color:var(--amber)"><?= $preconf_reg ?></div>
    <div class="sub">Across all sessions</div>
  </div>
  <div class="stat-card">
    <div class="label">🤝 Workshop Bookings</div>
    <div class="value" style="color:var(--amber)"><?= $ws_reg ?></div>
    <div class="sub">Across all workshops</div>
  </div>
  <div class="stat-card">
    <div class="label">🏆 Certificates</div>
    <div class="value" style="color:var(--purple)"><?= $certs ?></div>
    <div class="sub">Issued so far</div>
  </div>
</div>

<div class="card">
  <div class="card-header">
    <h3>📄 Recent Abstract Submissions</h3>
    <a href="abstracts.php" class="btn btn-blue btn-sm">View All</a>
  </div>
  <?php if (empty($recent)): ?>
    <div class="empty">No abstracts submitted yet.</div>
  <?php else: ?>
  <table>
    <thead>
      <tr><th>Title</th><th>Author</th><th>Status</th><th>Submitted</th></tr>
    </thead>
    <tbody>
    <?php foreach ($recent as $r): ?>
      <tr>
        <td><?= htmlspecialchars(mb_strimwidth($r['title'], 0, 60, '…')) ?></td>
        <td class="text-muted"><?= htmlspecialchars($r['author'] ?? '—') ?></td>
        <td>
          <?php
            $badge = match($r['status']) {
              'accepted' => 'badge-green',
              'rejected' => 'badge-red',
              default    => 'badge-amber',
            };
          ?>
          <span class="badge <?= $badge ?>"><?= ucfirst($r['status']) ?></span>
        </td>
        <td class="text-muted text-sm">
          <?= date('d M Y', strtotime($r['submitted_at'])) ?>
        </td>
      </tr>
    <?php endforeach; ?>
    </tbody>
  </table>
  <?php endif; ?>
</div>

</main></div>
</body></html>
