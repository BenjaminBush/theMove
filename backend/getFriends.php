<?php
    /**
     * Created by PhpStorm.
     * User: MaraEvans
     * Date: 3/29/17
     * Time: 1:33 PM
     */
    // Use htmlentities to parse bad strings
    require 'database.php';
    $current_user = $_REQUEST["user_id"];
    $stmt = $mysqli->prepare("SELECT member1_id, member2_id FROM connections where member1_id = $current_user && status LIKE 'ACCEPTED'");
    if (!$stmt) {
	printf("Query Prep Failed: %s\n", $mysqli->error);
	exit;
    }
    $stmt->execute();
    $result = $stmt->get_result();
    $num_friends = $result->num_rows;
    if ($num_friends == 0) {
        $returnArray["status"] = "0";
        $returnArray["message"] = "No friends. Add some!";
        echo json_encode($returnArray);
        return;
    }
        $returnArray["status"] = "1";
        $returnArray["message"] = "Loaded friends successfully!";
        $returnArray["num_friends"] = $num_friends;
        $index = 0;
    while($row = $result->fetch_assoc()) {
        $returnArray[$index]["member1_id"]= $row["member1_id"];
        $returnArray[$index]["member2_id"] = $row["member2_id"];
        $returnArray[$index]["status"] = $row["status"];
        $index += 1;
        }
        echo json_encode($returnArray);
        return;
    
?>