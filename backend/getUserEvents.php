<?php

    require 'database.php';
    $current_user = $_REQUEST["user_id"];
    $stmt = $mysqli->prepare("SELECT event_id, event_name, event_date FROM events where event_id in (select event_id from guests where guest_id = '$current_user')");
    if (!$stmt) {
	printf("Query Prep Failed: %s\n", $mysqli->error);
	exit;
    }

    $stmt->execute();
    $result = $stmt->get_result();
    $num_events = $result->num_rows;

    if ($num_events == 0) {
        $returnArray["status"] = "0";
        $returnArray["message"] = "No events found for this user";
        echo json_encode($returnArray);
        return;
    }


        $returnArray["status"] = "1";
        $returnArray["message"] = "Loaded events successfully!";
        $returnArray["num_events"] = $num_events;
        $index = 0;
    while($row = $result->fetch_assoc()) {
        $returnArray[$index]["event_id"]= $row["event_id"];
        $returnArray[$index]["event_name"] = $row["event_name"];
        $returnArray[$index]["event_date"] = $row["event_date"];
        $index += 1;
        }
        echo json_encode($returnArray);
        return;
    
?>