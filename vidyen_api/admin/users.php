<?php
require 'config.php';
requireAdminLogin();
$page = 'users'; $title = 'Users';
$db = db();

$users = $db->query(
    'SELECT u.*,
            (SELECT COUNT(*) FROM abstracts WHERE submitted_by=u.id) AS abstract_count,
            (SELECT COUNT(*) FROM preconf_registrations WHERE user_id=u.id) AS preconf_count,
            (SELECT COUNT(*) FROM workshop_registrations WHERE user_id=u.id) AS ws_count,
            (SELECT COUNT(*) FROM certificates WHERE user_id=u.id) AS cert_count
     FROM users u ORDER BY u.created_at DESC'
)->fetchAll();

include 'layout.php';
?>

<div class="page-header">
  <h2>👥 Users</h2>
  <p>All registered conference participants</p>
</div>

<div class="card">
  <div class="card-header">
    <h3>Registered Users (<?= count($users) ?>)</h3>
  </div>
  <?php if (empty($users)): ?>
    <div class="empty">No users registered yet.</div>
  <?php else: ?>
  <table>
    <thead>
      <tr>
        <th>Name</th><th>Email</th><th>Institution</th>
        <th>Abstracts</th><th>Pre-Conf</th><th>Workshops</th>
        <th>Certificates</th><th>Joined</th>
      </tr>
    </thead>
    <tbody>
    <?php foreach ($users as $u): ?>
    <tr>
      <td>
        <div style="font-weight:600"><?= htmlspecialchars($u['name']) ?></div>
        <div class="text-muted text-sm">@<?= htmlspecialchars($u['username'] ?? '—') ?></div>
        <?php if ($u['designation']): ?>
          <div class="text-muted text-sm"><?= htmlspecialchars($u['designation']) ?></div>
        <?php endif; ?>
      </td>
      <td class="text-muted text-sm"><?= htmlspecialchars($u['email']) ?></td>
      <td class="text-muted text-sm" style="max-width:160px">
        <?= htmlspecialchars($u['institution'] ?? '—') ?>
      </td>
      <td><span class="badge badge-blue"><?= $u['abstract_count'] ?></span></td>
      <td><span class="badge badge-amber"><?= $u['preconf_count'] ?></span></td>
      <td><span class="badge badge-amber"><?= $u['ws_count'] ?></span></td>
      <td><span class="badge badge-purple"><?= $u['cert_count'] ?></span></td>
      <td class="text-muted text-sm">
        <?= date('d M Y', strtotime($u['created_at'])) ?>
      </td>
    </tr>
    <?php endforeach; ?>
    </tbody>
  </table>
  <?php endif; ?>
</div>

</main></div></body></html>
