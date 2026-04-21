<?php
require 'config.php';
requireAdminLogin();
$page = 'abstracts'; $title = 'Abstracts';
$db = db();

// Handle status update
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    if ($_POST['action'] === 'update_status') {
        $id     = (int)$_POST['id'];
        $status = in_array($_POST['status'], ['pending','accepted','rejected'])
                  ? $_POST['status'] : 'pending';
        $db->prepare('UPDATE abstracts SET status=? WHERE id=?')
           ->execute([$status, $id]);
        flash('success', 'Abstract status updated to ' . ucfirst($status) . '.');
    }
    header('Location: abstracts.php');
    exit;
}

$filter = $_GET['status'] ?? 'all';
$sql = 'SELECT a.*, u.name AS submitted_by_name
        FROM abstracts a LEFT JOIN users u ON a.submitted_by = u.id';
$args = [];
if ($filter !== 'all') {
    $sql  .= ' WHERE a.status = ?';
    $args[] = $filter;
}
$sql .= ' ORDER BY a.submitted_at DESC';
$stmt = $db->prepare($sql);
$stmt->execute($args);
$abstracts = $stmt->fetchAll();

$stats = $db->query(
    "SELECT status, COUNT(*) c FROM abstracts GROUP BY status"
)->fetchAll(PDO::FETCH_KEY_PAIR);

include 'layout.php';
?>

<div class="page-header">
  <h2>📄 Abstracts Management</h2>
  <p>Review and update the status of submitted abstracts</p>
</div>

<!-- Filter tabs -->
<div style="display:flex;gap:8px;margin-bottom:20px;flex-wrap:wrap">
  <?php foreach(['all'=>'All','pending'=>'Pending','accepted'=>'Accepted','rejected'=>'Rejected'] as $k=>$v): ?>
    <a href="?status=<?= $k ?>"
       class="btn <?= $filter===$k ? 'btn-teal' : 'btn-blue' ?> btn-sm">
      <?= $v ?>
      <?php $cnt = $k==='all' ? array_sum($stats) : ($stats[$k]??0); ?>
      <span style="background:rgba(0,0,0,.2);padding:1px 7px;border-radius:10px;font-size:11px">
        <?= $cnt ?>
      </span>
    </a>
  <?php endforeach; ?>
</div>

<div class="card">
  <div class="card-header">
    <h3>Submissions (<?= count($abstracts) ?>)</h3>
  </div>
  <?php if (empty($abstracts)): ?>
    <div class="empty">No abstracts found.</div>
  <?php else: ?>
  <table>
    <thead>
      <tr>
        <th>#</th><th>Title</th><th>Authors</th><th>Category</th>
        <th>Type</th><th>Status</th><th>Submitted</th><th>Action</th>
      </tr>
    </thead>
    <tbody>
    <?php foreach ($abstracts as $a): ?>
    <tr>
      <td class="text-muted text-sm"><?= $a['id'] ?></td>
      <td>
        <div style="font-weight:600;max-width:260px">
          <?= htmlspecialchars(mb_strimwidth($a['title'],0,70,'…')) ?>
        </div>
        <div class="text-muted text-sm">
          <?= htmlspecialchars($a['institution']) ?>
        </div>
      </td>
      <td class="text-muted text-sm" style="max-width:140px">
        <?= htmlspecialchars($a['authors']) ?>
      </td>
      <td><span class="badge badge-blue"><?= htmlspecialchars($a['category']) ?></span></td>
      <td class="text-muted text-sm">
        <?= $a['presentation_type'] === 'oral' ? '🎤 Oral' : '🖼️ Poster' ?>
      </td>
      <td>
        <?php $badge = match($a['status']) {
          'accepted'=>'badge-green','rejected'=>'badge-red',default=>'badge-amber'}; ?>
        <span class="badge <?= $badge ?>"><?= ucfirst($a['status']) ?></span>
      </td>
      <td class="text-muted text-sm">
        <?= date('d M Y', strtotime($a['submitted_at'])) ?>
      </td>
      <td>
        <form method="POST" style="display:flex;gap:6px">
          <input type="hidden" name="action" value="update_status">
          <input type="hidden" name="id" value="<?= $a['id'] ?>">
          <select name="status" style="padding:5px 8px;font-size:12px;width:auto">
            <option value="pending"  <?= $a['status']==='pending'  ?'selected':'' ?>>Pending</option>
            <option value="accepted" <?= $a['status']==='accepted' ?'selected':'' ?>>Accepted</option>
            <option value="rejected" <?= $a['status']==='rejected' ?'selected':'' ?>>Rejected</option>
          </select>
          <button class="btn btn-teal btn-sm" type="submit">Save</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
    </tbody>
  </table>
  <?php endif; ?>
</div>

</main></div></body></html>
