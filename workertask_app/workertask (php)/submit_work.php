<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$work_id = $_POST['work_id'];
$worker_id = $_POST['worker_id'];
$submission_text = $_POST['submission_text'];
$submitted_at = date('Y-m-d H:i:s'); // Current server time

$sqlinsert = "INSERT INTO `tbl_submissions`(work_id, worker_id, submission_text, submitted_at) VALUES ('$work_id', '$worker_id', '$submission_text', '$submitted_at')";

try {
    if ($conn->query($sqlinsert) === TRUE) {
        // Optionally update task status
        $sqlupdatestatus = "UPDATE `tbl_works` SET status = 'complete' WHERE id = '$work_id'";
        $conn->query($sqlupdatestatus);

        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
} catch (Exception $e) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
