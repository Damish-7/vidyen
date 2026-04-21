<?php
require 'config.php';
requireAdminLogin();
$page = 'certificates'; $title = 'Certificates';
$db = db();

// Handle actions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';

    // Issue single certificate
    if ($action === 'issue') {
        $userId    = (int)$_POST['user_id'];
        $type      = $_POST['type'];
        $eventName = trim($_POST['event_name']);
        $issuedAt  = $_POST['issued_at'];

        $titles = [
            'participation' => 'Certificate of Participation',
            'presenter'     => 'Certificate of Presentation',
            'workshop'      => 'Workshop Completion Certificate',
            'preconf'       => 'Pre-Conference Completion Certificate',
        ];
        $title_cert = $titles[$type] ?? 'Certificate';
        $code = generateCertCode($type);

        $db->prepare(
            'INSERT INTO certificates (user_id, type, title, event_name, issued_at, certificate_code)
             VALUES (?,?,?,?,?,?)'
        )->execute([$userId, $type, $title_cert, $eventName, $issuedAt, $code]);
        flash('success', "Certificate issued successfully. Code: $code");
    }

    // Bulk issue participation to all users
    if ($action === 'bulk_participation') {
        $eventName = trim($_POST['event_name']);
        $issuedAt  = $_POST['issued_at'];
        $users = $db->query('SELECT id FROM users')->fetchAll();
        $count = 0;
        foreach ($users as $u) {
            // Skip if already has participation cert for this event
            $exists = $db->prepare(
                "SELECT id FROM certificates WHERE user_id=? AND type='participation' AND event_name=?"
            );
            $exists->execute([$u['id'], $eventName]);
            if ($exists->fetch()) continue;

            $code = generateCertCode('participation');
            $db->prepare(
                'INSERT INTO certificates (user_id, type, title, event_name, issued_at, certificate_code)
                 VALUES (?,?,?,?,?,?)'
            )->execute([
                $u['id'], 'participation',
                'Certificate of Participation',
                $eventName, $issuedAt, $code
            ]);
            $count++;
        }
        flash('success', "Issued participation certificates to $count users.");
    }

    // Bulk issue to all workshop registrants of a specific workshop
    if ($action === 'bulk_workshop') {
        $workshopId = (int)$_POST['workshop_id'];
        $issuedAt   = $_POST['issued_at'];

        $ws = $db->prepare('SELECT title FROM workshops WHERE id=?');
        $ws->execute([$workshopId]);
        $workshop = $ws->fetch();
        if (!$workshop) { flash('error', 'Workshop not found.'); header('Location: certificates.php'); exit; }

        $regs = $db->prepare(
            'SELECT user_id FROM workshop_registrations WHERE workshop_id=?'
        );
        $regs->execute([$workshopId]);
        $count = 0;
        foreach ($regs->fetchAll() as $r) {
            $exists = $db->prepare(
                "SELECT id FROM certificates WHERE user_id=? AND type='workshop' AND event_name=?"
            );
            $exists->execute([$r['user_id'], $workshop['title']]);
            if ($exists->fetch()) continue;

            $code = generateCertCode('workshop');
            $db->prepare(
                'INSERT INTO certificates (user_id, type, title, event_name, issued_at, certificate_code)
                 VALUES (?,?,?,?,?,?)'
            )->execute([
                $r['user_id'], 'workshop',
                'Workshop Completion Certificate',
                $workshop['title'], $issuedAt, $code
            ]);
            $count++;
        }
        flash('success', "Issued workshop certificates to $count participants.");
    }

    // Delete certificate
    if ($action === 'delete') {
        $db->prepare('DELETE FROM certificates WHERE id=?')
           ->execute([(int)$_POST['cert_id']]);
        flash('success', 'Certificate deleted.');
    }

    header('Location: certificates.php');
    exit;
}

$certs = $db->query(
    'SELECT c.*, u.name AS user_name, u.email AS user_email
     FROM certificates c JOIN users u ON c.user_id = u.id
     ORDER BY c.issued_at DESC, c.id DESC'
)->fetchAll();

$users     = $db->query('SELECT id, name, email FROM users ORDER BY name')->fetchAll();
$workshops = $db->query('SELECT id, title FROM workshops ORDER BY title')->fetchAll();

$page = 'certificates'; $title = 'Certificates';
include 'layout.php';
?>

<div class="page-header" style="display:flex;justify-content:space-between;align-items:flex-start">
  <div>
    <h2>🏆 Certificates</h2>
    <p>Issue and manage participant certificates</p>
  </div>
  <div style="display:flex;gap:8px">
    <button class="btn btn-teal" onclick="openModal('modal-issue')">
      + Issue Certificate
    </button>
    <button class="btn btn-blue" onclick="openModal('modal-bulk')">
      ⚡ Bulk Issue
    </button>
  </div>
</div>

<!-- Certificates table -->
<div class="card">
  <div class="card-header">
    <h3>All Certificates (<?= count($certs) ?>)</h3>
  </div>
  <?php if (empty($certs)): ?>
    <div class="empty">No certificates issued yet. Click "Issue Certificate" to get started.</div>
  <?php else: ?>
  <table>
    <thead>
      <tr>
        <th>Recipient</th><th>Type</th><th>Event</th>
        <th>Code</th><th>Issued</th><th>Downloaded</th><th>Action</th>
      </tr>
    </thead>
    <tbody>
    <?php foreach ($certs as $c):
      $typeBadge = match($c['type']) {
        'participation' => ['badge-purple','Participation'],
        'presenter'     => ['badge-teal','Presenter'],
        'workshop'      => ['badge-amber','Workshop'],
        'preconf'       => ['badge-blue','Pre-Conf'],
        default         => ['badge-blue',$c['type']],
      };
    ?>
    <tr>
      <td>
        <div style="font-weight:600"><?= htmlspecialchars($c['user_name']) ?></div>
        <div class="text-muted text-sm"><?= htmlspecialchars($c['user_email']) ?></div>
      </td>
      <td><span class="badge <?= $typeBadge[0] ?>"><?= $typeBadge[1] ?></span></td>
      <td class="text-sm" style="max-width:200px">
        <?= htmlspecialchars(mb_strimwidth($c['event_name'],0,50,'…')) ?>
      </td>
      <td class="text-muted text-sm" style="font-family:monospace">
        <?= htmlspecialchars($c['certificate_code']) ?>
      </td>
      <td class="text-muted text-sm">
        <?= date('d M Y', strtotime($c['issued_at'])) ?>
      </td>
      <td>
        <?php if ($c['is_downloaded']): ?>
          <span class="badge badge-green">✓ Yes</span>
        <?php else: ?>
          <span class="badge badge-amber">Pending</span>
        <?php endif; ?>
      </td>
      <td>
        <form method="POST">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="cert_id" value="<?= $c['id'] ?>">
          <button class="btn btn-red btn-sm" type="submit"
            onclick="return confirm('Delete this certificate?')">Delete</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
    </tbody>
  </table>
  <?php endif; ?>
</div>

<!-- ── Modal: Issue single certificate ─────────────────────────────────── -->
<div class="modal-overlay" id="modal-issue">
  <div class="modal">
    <h3>🏆 Issue Certificate</h3>
    <form method="POST">
      <input type="hidden" name="action" value="issue">
      <div class="form-grid">
        <div class="form-group span2">
          <label>Recipient User *</label>
          <select name="user_id" required>
            <option value="">— Select user —</option>
            <?php foreach ($users as $u): ?>
              <option value="<?= $u['id'] ?>">
                <?= htmlspecialchars($u['name']) ?> (<?= htmlspecialchars($u['email']) ?>)
              </option>
            <?php endforeach; ?>
          </select>
        </div>
        <div class="form-group">
          <label>Certificate Type *</label>
          <select name="type" required>
            <option value="participation">Participation</option>
            <option value="presenter">Presenter</option>
            <option value="workshop">Workshop Completion</option>
            <option value="preconf">Pre-Conference Completion</option>
          </select>
        </div>
        <div class="form-group">
          <label>Issue Date *</label>
          <input type="date" name="issued_at" value="<?= date('Y-m-d') ?>" required>
        </div>
        <div class="form-group span2">
          <label>Event Name *</label>
          <input type="text" name="event_name"
            placeholder="e.g. VIDYEN Annual Conference 2025" required>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-red" onclick="closeModal('modal-issue')">
          Cancel
        </button>
        <button type="submit" class="btn btn-teal">Issue Certificate</button>
      </div>
    </form>
  </div>
</div>

<!-- ── Modal: Bulk issue ────────────────────────────────────────────────── -->
<div class="modal-overlay" id="modal-bulk">
  <div class="modal">
    <h3>⚡ Bulk Issue Certificates</h3>

    <p class="text-muted text-sm" style="margin-bottom:20px">
      Issue certificates to multiple users at once. Duplicates are automatically skipped.
    </p>

    <!-- Bulk: Participation to ALL users -->
    <div class="section-title">Option 1 — Participation to All Users</div>
    <form method="POST" style="margin-bottom:24px">
      <input type="hidden" name="action" value="bulk_participation">
      <div class="form-grid">
        <div class="form-group">
          <label>Event Name *</label>
          <input type="text" name="event_name"
            value="VIDYEN Annual Conference 2025" required>
        </div>
        <div class="form-group">
          <label>Issue Date *</label>
          <input type="date" name="issued_at" value="<?= date('Y-m-d') ?>" required>
        </div>
      </div>
      <button type="submit" class="btn btn-teal mt-16"
        onclick="return confirm('Issue participation certificates to ALL registered users?')">
        Issue to All Users
      </button>
    </form>

    <!-- Bulk: Workshop completion to workshop registrants -->
    <div class="section-title">Option 2 — Workshop Certificate to Registrants</div>
    <form method="POST">
      <input type="hidden" name="action" value="bulk_workshop">
      <div class="form-grid">
        <div class="form-group span2">
          <label>Select Workshop *</label>
          <select name="workshop_id" required>
            <option value="">— Select workshop —</option>
            <?php foreach ($workshops as $w): ?>
              <option value="<?= $w['id'] ?>">
                <?= htmlspecialchars($w['title']) ?>
              </option>
            <?php endforeach; ?>
          </select>
        </div>
        <div class="form-group">
          <label>Issue Date *</label>
          <input type="date" name="issued_at" value="<?= date('Y-m-d') ?>" required>
        </div>
      </div>
      <button type="submit" class="btn btn-amber mt-16"
        onclick="return confirm('Issue workshop certificates to all registrants of the selected workshop?')">
        Issue to Workshop Registrants
      </button>
    </form>

    <div class="modal-footer">
      <button type="button" class="btn btn-red" onclick="closeModal('modal-bulk')">
        Close
      </button>
    </div>
  </div>
</div>

<script>
function openModal(id)  { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }
document.querySelectorAll('.modal-overlay').forEach(o => {
  o.addEventListener('click', e => { if (e.target===o) o.classList.remove('open'); });
});
</script>

</main></div></body></html>
