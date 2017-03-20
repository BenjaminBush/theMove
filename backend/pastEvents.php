<?php
    // Use htmlentities to parse bad strings
    $userID = htmlentities($_REQUEST["id"]);

    require 'database.php';
	
    $stmt = $mysqli->prepare("SELECT COUNT(*) FROM users");
    if (!$stmt) {
		printf("Query Prep Failed: %s\n", $mysqli->error);
		exit;
    }

    $stmt->execute();
    $result = $mysqli->get_result();
    while($row = $result->fetch_assoc()) {
        if($row['username'] == $username) {
            header("Location: failure.php");
        }
    }

    $stmt2 = $mysqli->prepare("SELECT pastEvents FROM users WHERE id=$userID");
    
    if (!$stmt2) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }

    $stmt2->bind_param($prevEvents);
    $stmt2->execute();
	
    if ($stmt2) {
        $returnArray["status"] = "200";
		$returnArray["message"] = "OK";
		echo json_encode($returnArray);
    } else {
		$returnArray["status"] = "400";
		$returnArray["message"] = "Failed to insert user into the database";
		echo json_encode($returnArray);
    }
    
    
    ?>