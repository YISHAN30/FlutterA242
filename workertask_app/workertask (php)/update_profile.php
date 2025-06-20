<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");

if (!isset($_POST['worker_id']) || !isset($_POST['worker_name']) || 
    !isset($_POST['worker_email']) || !isset($_POST['worker_phone'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$worker_id = $_POST['worker_id'];
$name = $_POST['worker_name'];
$email = $_POST['worker_email'];
$phone = $_POST['worker_phone'];
$address = isset($_POST['worker_address']) ? $_POST['worker_address'] : '';

$sql = "UPDATE tbl_workers SET 
        worker_name = '$name', 
        worker_email = '$email', 
        worker_phone = '$phone', 
        worker_address = '$address' 
        WHERE worker_id = '$worker_id'";

if ($conn->query($sql) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
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