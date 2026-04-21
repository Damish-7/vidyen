<?php
require 'config.php';
requireAdminLogin();
$page = 'preconf'; $title = 'Pre-Conference';
$db = db();

$sessions = $db->query(
    'SELECT s.*,
            (SELECT COUNT(*) FROM preconf_registrations WHERE session_id=s.id) AS reg_count
     FROM preconf_sessions s ORDER BY s.session_date, s.session_time'
)->fetchAll();

// Get registrations per session when expanded
$sessionId = isset($_GET['session']) ? (int)$_GET['session'] : null;
$registrants = [];
if ($sessionId) {
    $registrants = $db->prepare(
        'SELECT u.name, u.email, u.institution, r.created_at
         FROM preconf_registrations r JOIN users u ON r.user_id=u.id
         WHERE r.session_id=? ORDER BY r.created_at'
    );
    $registrants->execute([$sessionId]);
    $registrants = $registrants->fetchAll();
}

include 'layout.php';
?>

<div class="page-header">
  <h2>📅 Pre-Conference Sessions</h2>
  <p>View registration counts and participant lists</p>
</div>

<?php foreach ($sessions as $s):
  $fillPct = $s['max_participants'] > 0
    ? min(100, round($s['reg_count'] / $s['max_participants'] * 100)) : 0;
  $isExpanded = $sessionId === (int)$s['id'];
?>
<div class="card" style="margin-bottom:16px">
  <div class="card-header">
    <div>
      <h3><?= htmlspecialchars($s['title']) ?></h3>
      <div class="text-muted text-sm" style="margin-top:4px">
        <?= htmlspecialchars($s['speaker']) ?> · <?= htmlspecialchars($s['session_time']) ?>
        · <?= htmlspecialchars($s['venue']) ?>
      </div>
    </div>
    <div style="display:flex;align-items:center;gap:12px">
      <div style="text-align:right">
        <div style="font-size:20px;font-weight:800;color:var(--teal)">
          <?= $s['reg_count'] ?>/<?= $s['max_participants'] ?>
        </div>
        <div class="text-muted text-sm">Registered</div>
      </div>
      <a href="?session=<?= $isExpanded ? '' : $s['id'] ?>"
         class="btn btn-blue btn-sm">
        <?= $isExpanded ? 'Hide' : 'View' ?> List
      </a>
    </div>
  </div>

  <!-- Capacity bar -->
  <div style="padding:0 20px 16px">
    <div style="background:rgba(30,58,95,.5);border-radius:4px;height:6px">
      <div style="height:6px;border-radius:4px;width:<?= $fillPct ?>%;
        background:<?= $fillPct>=100?'var(--red)':'var(--teal)' ?>;
        transition:width .3s"></div>
    </div>
    <div class="text-muted text-sm" style="margin-top:6px"><?= $fillPct ?>% full</div>
  </div>

  <?php if ($isExpanded): ?>
  <?php if (empty($registrants)): ?>
    <div class="empty">No registrations yet for this session.</div>
  <?php else: ?>
  <table>
    <thead>
      <tr><th>Name</th><th>Email</th><th>Institution</th><th>Registered At</th></tr>
    </thead>
    <tbody>
    <?php foreach ($registrants as $r): ?>
    <tr>
      <td style="font-weight:600"><?= htmlspecialchars($r['name']) ?></td>
      <td class="text-muted text-sm"><?= htmlspecialchars($r['email']) ?></td>
      <td class="text-muted text-sm"><?= htmlspecialchars($r['institution'] ?? '—') ?></td>
      <td class="text-muted text-sm">
        <?= date('d M Y H:i', strtotime($r['created_at'])) ?>
      </td>
    </tr>
    <?php endforeach; ?>
    </tbody>
  </table>
  <?php endif; ?>
  <?php endif; ?>
</div>
<?php endforeach; ?>

</main></div></body></html>
