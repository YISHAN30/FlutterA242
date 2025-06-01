<?php
require_once 'dbconnect.php';

$worker_name = $_POST['worker_name'] ?? '';
$worker_email = $_POST['worker_email'] ?? '';
$worker_password = $_POST['worker_password'] ?? '';
$worker_phone = $_POST['worker_phone'] ?? '';

$response = array();

if ($worker_name && $worker_email && $worker_password && $worker_phone) {
    $checkSql = "SELECT * FROM os_worker WHERE worker_email = ?";
    $stmt = $conn->prepare($checkSql);
    $stmt->bind_param("s", $worker_email);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        $response['status'] = 'failed';
        $response['message'] = 'Email already registered';
    } else {
        $insertSql = "INSERT INTO os_worker (worker_name, worker_email, worker_password, worker_phone) VALUES (?, ?, ?, ?)";
        $stmt = $conn->prepare($insertSql);
        $hashed_password = password_hash($worker_password, PASSWORD_DEFAULT);
        $stmt->bind_param("ssss", $worker_name, $worker_email, $hashed_password, $worker_phone);
        if ($stmt->execute()) {
            $response['status'] = 'success';
            $response['message'] = 'Register successful';
        } else {
            $response['status'] = 'failed';
            $response['message'] = 'Register failed';
        }
    }
} else {
    $response['status'] = 'failed';
    $response['message'] = 'Missing required fields';
}

echo json_encode($response);
$conn->close();
?>