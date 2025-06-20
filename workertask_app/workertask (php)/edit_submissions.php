<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json');

if (!isset($_POST['submission_id']) || !isset($_POST['updated_text'])) {
    echo json_encode(['status' => 'failed', 'data' => null, 'error' => 'Missing parameters']);
    exit();
}

include_once("dbconnect.php");

$submission_id = $_POST['submission_id'];
$updated_text = $_POST['updated_text'];

$stmt = $conn->prepare("UPDATE tbl_submissions SET submission_text = ? WHERE id = ?");
$stmt->bind_param("si", $updated_text, $submission_id);

if ($stmt->execute()) {
    echo json_encode(['status' => 'success', 'data' => null]);
} else {
    echo json_encode(['status' => 'failed', 'error' => $stmt->error]);
}

$stmt->close();
$conn->close();
?>
