<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");

if (!isset($_POST['worker_id'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$worker_id = $_POST['worker_id'];

$sql = "SELECT worker_id, worker_name, worker_email, worker_phone, worker_address 
        FROM tbl_workers 
        WHERE worker_id = '$worker_id'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $response = array('status' => 'success', 'data' => $row);
} else {
    $response = array('status' => 'failed', 'data' => null);
}
sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>