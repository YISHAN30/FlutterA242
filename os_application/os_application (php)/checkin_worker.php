<?php
require_once 'dbconnect.php';

$worker_id = $_POST['worker_id'] ?? '';
$worker_name = $_POST['worker_name'] ?? '';
$checkin_date = $_POST['checkin_date'] ?? '';
$checkin_time = $_POST['checkin_time'] ?? '';
$latitude = $_POST['latitude'] ?? '';
$longitude = $_POST['longitude'] ?? '';
// Assume photo is uploaded as base64 or multipart, omitted here for brevity

$response = array();

if ($worker_id && $worker_name && $checkin_date && $checkin_time && $latitude && $longitude) {
    $sql = "INSERT INTO checkin_worker (worker_id, worker_name, checkin_date, checkin_time, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssssdd", $worker_id, $worker_name, $checkin_date, $checkin_time, $latitude, $longitude);

    if ($stmt->execute()) {
        $response['status'] = 'success';
        $response['message'] = 'Check-in recorded successfully';
    } else {
        $response['status'] = 'failed';
        $response['message'] = 'Failed to record check-in';
    }
} else {
    $response['status'] = 'failed';
    $response['message'] = 'Missing required fields';
}

echo json_encode($response);
$conn->close();
?>