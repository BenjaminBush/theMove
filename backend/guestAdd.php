<?php

    require 'database.php';
    $event_id = $_REQUEST["event_id"];
    $user_id = $_REQUEST["user_id"]; 
    $stmt = $mysqli->prepare("INSERT INTO guests (event_id, guest_id) VALUES ('$event_id', '$user_id')");

    if (!$stmt) {
	printf("Query Prep Failed: %s\n", $mysqli->error);
	exit;
    }

    if ($stmt->execute()) {
    
        $stmt2 = $mysqli->prepare("UPDATE events SET numGuests = numGuests + 1 WHERE event_id = '$event_id'");
        if (!$stmt2) {
	        printf("Numguests change query Prep Failed: %s\n", $mysqli->error);
	        exit;
            }
        $stmt2->execute();
        $returnArray["status"] = "1";
        $returnArray["message"] = "guest added";
        echo json_encode($returnArray);
        return;
    }

    else {
        $returnArray["status"] = "0";
        $returnArray["message"] = "guest not added";
        echo json_encode($returnArray);
        return;
    }
    
?>