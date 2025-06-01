<?php
require_once 'dbconnect.php';

$worker_email = $_POST['worker_email'] ?? '';
$worker_password = $_POST['worker_password'] ?? '';

$response = array();

if ($worker_email && $worker_password) {
    $sql = "SELECT * FROM os_worker WHERE worker_email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $worker_email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $worker = $result->fetch_assoc();
        if (password_verify($worker_password, $worker['worker_password'])) {
            $response['status'] = 'success';
            $response['data'] = array($worker);
        } else {
            $response['status'] = 'failed';
            $response['message'] = 'Incorrect password';
        }
    } else {
        $response['status'] = 'failed';
        $response['message'] = 'Email not found';
    }
} else {
    $response['status'] = 'failed';
    $response['message'] = 'Missing email or password';
}

echo json_encode($response);
$conn->close();
?>