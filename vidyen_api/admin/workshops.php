<?php
require 'config.php';
requireAdminLogin();
$page = 'workshops'; $title = 'Workshops';
$db = db();

$workshops = $db->query(
    'SELECT w.*,
            (SELECT COUNT(*) FROM workshop_registrations WHERE workshop_id=w.id) AS reg_count
     FROM workshops w ORDER BY w.workshop_date, w.workshop_time'
)->fetchAll();

$workshopId = isset($_GET['workshop']) ? (int)$_GET['workshop'] : null;
$registrants = [];
if ($workshopId) {
    $stmt = $db->prepare(
        'SELECT u.name, u.email, u.institution, r.created_at
         FROM workshop_registrations r JOIN users u ON r.user_id=u.id
         WHERE r.workshop_id=? ORDER BY r.created_at'
    );
    $stmt->execute([$workshopId]);
    $registrants = $stmt->fetchAll();
}

include 'layout.php';
?>

<div class="page-header">
  <h2>🤝 Workshops</h2>
  <p>View registration counts and participant lists</p>
</div>

<?php foreach ($workshops as $w):
  $fillPct = $w['max_participants'] > 0
    ? min(100, round($w['reg_count'] / $w['max_participants'] * 100)) : 0;
  $isExpanded = $workshopId === (int)$w['id'];
?>
<div class="card" style="margin-bottom:16px">
  <div class="card-header">
    <div>
      <h3><?= htmlspecialchars($w['title']) ?></h3>
      <div class="text-muted text-sm" style="margin-top:4px">
        <?= htmlspecialchars($w['facilitator']) ?> · <?= htmlspecialchars($w['workshop_time']) ?>
        · <?= htmlspecialchars($w['duration']) ?> · <?= htmlspecialchars($w['venue']) ?>
      </div>
    </div>
    <div style="display:flex;align-items:center;gap:12px">
      <div style="text-align:right">
        <div style="font-size:20px;font-weight:800;color:var(--amber)">
          <?= $w['reg_count'] ?>/<?= $w['max_participants'] ?>
        </div>
        <div class="text-muted text-sm">Booked</div>
      </div>
      <a href="?workshop=<?= $isExpanded ? '' : $w['id'] ?>"
         class="btn btn-amber btn-sm">
        <?= $isExpanded ? 'Hide' : 'View' ?> List
      </a>
    </div>
  </div>

  <div style="padding:0 20px 16px">
    <div style="background:rgba(30,58,95,.5);border-radius:4px;height:6px">
      <div style="height:6px;border-radius:4px;width:<?= $fillPct ?>%;
        background:<?= $fillPct>=100?'var(--red)':'var(--amber)' ?>;
        transition:width .3s"></div>
    </div>
    <div class="text-muted text-sm" style="margin-top:6px"><?= $fillPct ?>% full</div>
  </div>

  <?php if ($isExpanded): ?>
  <?php if (empty($registrants)): ?>
    <div class="empty">No registrations yet for this workshop.</div>
  <?php else: ?>
  <table>
    <thead>
      <tr><th>Name</th><th>Email</th><th>Institution</th><th>Booked At</th></tr>
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
