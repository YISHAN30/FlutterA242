<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
error_reporting(0);
header("Access-Control-Allow-Origin: *");

if (!isset($_POST['worker_email']) || !isset($_POST['worker_password'])) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$email = $_POST['worker_email'];
$password = sha1($_POST['worker_password']);

$sqllogin = "SELECT * FROM `tbl_workers` WHERE worker_email = '$email' AND worker_password = '$password'";
$result = $conn->query($sqllogin);
if ($result->num_rows > 0) {
    $sentArray = array();
    while ( $row = $result->fetch_assoc() ) {
        $sentArray[] = $row;
    }
    $response = array('status' => 'success', 'data' =>  $sentArray);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}	


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>