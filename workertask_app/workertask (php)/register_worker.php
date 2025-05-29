<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");

if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$worker_id = $_POST['worker_id'];
$worker_name = $_POST['worker_name'];
$worker_email = $_POST['worker_email'];
$worker_password = sha1($_POST['worker_password']);
$worker_phone = $_POST['worker_phone'];
$worker_address = $_POST['worker_address'];

$sqlinsert="INSERT INTO `tbl_workers`(`worker_name`, `worker_email`, `worker_password`, `worker_phone`, `worker_address`) VALUES ('$worker_name','$worker_email','$worker_password','$worker_phone','$worker_address')";

try{
    if ($conn->query($sqlinsert) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }   
}catch (Exception $e) {
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