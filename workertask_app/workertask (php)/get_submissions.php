<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json');

$worker_id = $_POST['worker_id'] ?? $_GET['worker_id'] ?? null;

if (!$worker_id) {
    echo json_encode(['status' => 'failed', 'message' => 'Missing worker_id']);
    exit();
}

include_once("dbconnect.php");

$sql = "SELECT 
          s.id,
          s.work_id,
          s.worker_id,
          w.title,
          s.submission_text,
          s.submitted_at
        FROM tbl_submissions s
        JOIN tbl_works w ON s.work_id = w.id
        WHERE s.worker_id = '$worker_id'
        ORDER BY s.submitted_at DESC";

$result = $conn->query($sql);

$submissions = [];
if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $submissions[] = [
            'id' => $row['id'],
            'work_id' => $row['work_id'],
            'worker_id' => $row['worker_id'],
            'title' => $row['title'],
            'submission_text' => $row['submission_text'],
            'submitted_at' => $row['submitted_at'],
        ];
    }
    echo json_encode(['status' => 'success', 'data' => $submissions]);
} else {

    echo json_encode(['status' => 'success', 'data' => []]);
}
?>
