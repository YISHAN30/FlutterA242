<?php
require_once 'dbconnect.php';

$worker_id = $_POST['worker_id'] ?? '';
$worker_name = $_POST['worker_name'] ?? '';
$submission_date = $_POST['submission_date'] ?? '';
$tasks_completed = $_POST['tasks_completed'] ?? ''; // Could be a JSON string or comma separated list

$response = array();

if ($worker_id && $worker_name && $submission_date && $tasks_completed) {
    $sql = "INSERT INTO tasksubmission_worker (worker_id, worker_name, submission_date, tasks_completed) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssss", $worker_id, $worker_name, $submission_date, $tasks_completed);

    if ($stmt->execute()) {
        $response['status'] = 'success';
        $response['message'] = 'Task submission recorded successfully';
    } else {
        $response['status'] = 'failed';
        $response['message'] = 'Failed to record task submission';
    }
} else {
    $response['status'] = 'failed';
    $response['message'] = 'Missing required fields';
}

echo json_encode($response);
$conn->close();
?>