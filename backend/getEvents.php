<?php
    /**
     * Created by PhpStorm.
     * User: benbush
     * Date: 2/18/17
     * Time: 1:33 PM
     */
    // Use htmlentities to parse bad strings


    //$username = htmlentities($_REQUEST["username"]);
 
    // Make sure all variables have value
    // if (empty($username)) {
    //     $returnArray["status"] = "500";
    //     $returnArray["message"] = "User not logged in";
    //     echo json_encode($returnArray);
    //     return;
    // }

    require 'database.php';
    $stmt = $mysqli->prepare("SELECT event_id, event_name, event_date, numGuests FROM events where active = 1");
    if (!$stmt) {
	printf("Query Prep Failed: %s\n", $mysqli->error);
	exit;
    }

    $stmt->execute();
    $result = $stmt->get_result();
    $num_events = $result->num_rows;

    if ($num_events == 0) {
        $returnArray["status"] = "0";
        $returnArray["message"] = "No events found. Try creating one yourself!";
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
        $returnArray[$index]["numGuests"] = $row["numGuests"];
        $index += 1;
        }
        echo json_encode($returnArray);
        return;
    
?>
