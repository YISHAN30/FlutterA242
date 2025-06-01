<?php
require_once 'dbconnect.php';

$worker_id = $_POST['worker_id'] ?? '';
$worker_name = $_POST['worker_name'] ?? '';
$checkout_date = $_POST['checkout_date'] ?? '';
$checkout_time = $_POST['checkout_time'] ?? '';
$latitude = $_POST['latitude'] ?? '';
$longitude = $_POST['longitude'] ?? '';

$response = array();

if ($worker_id && $worker_name && $checkout_date && $checkout_time && $latitude && $longitude) {
    $sql = "INSERT INTO checkout_worker (worker_id, worker_name, checkout_date, checkout_time, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssssdd", $worker_id, $worker_name, $checkout_date, $checkout_time, $latitude, $longitude);

    if ($stmt->execute()) {
        $response['status'] = 'success';
        $response['message'] = 'Checkout recorded successfully';
    } else {
        $response['status'] = 'failed';
        $response['message'] = 'Failed to record checkout';
    }
} else {
    $response['status'] = 'failed';
    $response['message'] = 'Missing required fields';
}

echo json_encode($response);
$conn->close();
?>