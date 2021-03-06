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
    $event_id = $_REQUEST["event_id"];
    $current_user = $_REQUEST["user_id"];
    $stmt = $mysqli->prepare("SELECT events.event_address, events.category, users.first_name, users.last_name from events join users on events.host_id  = users.user_id where event_id = '$event_id'");

    if (!$stmt) {
	printf("Query Prep Failed: %s\n", $mysqli->error);
	exit;
    }

    $stmt->execute();
    $result = $stmt->get_result();
    $num_events = $result->num_rows;

    if ($num_events == 0) {
        $returnArray["status"] = "0";
        $returnArray["message"] = "Event not found!";
        echo json_encode($returnArray);
        return;
    }


        $returnArray["status"] = "1";
        $returnArray["message"] = "Loaded event detail successfully!";
        
        $details = $result->fetch_assoc();
        
        
        $returnArray["event_address"]= $details["event_address"];
        $returnArray["category"] = $details["category"];
        $returnArray["host_firstname"] = $details["first_name"];
        $returnArray["host_lastname"] = $details["last_name"];
        
        $stmt2 = $mysqli->prepare("select first_name, last_name from users where user_id in (select guest_id from guests where event_id = '$event_id') AND (user_id in (select member1_id from connections where member2_id = '$current_user' and status = \"ACCEPTED\") OR user_id in (select member2_id from connections where member1_id = '$current_user' and status = \"ACCEPTED\"))");
        if (!$stmt2) {
	        printf("Friends attending event Prep Failed: %s\n", $mysqli->error);
	    exit;
        }
        
        $stmt2->execute();
        $friends_attending = $stmt2->get_result();
        
        $returnArray["numFriendsAttending"] = $friends_attending-> num_rows;
        
        $index = 0;
        while ($row = $friends_attending->fetch_assoc()){ 
            $returnArray["friends"][$index]["first_name"]= $row["first_name"];
            $returnArray["friends"][$index]["last_name"]= $row["last_name"];
            $index += 1;
        }
        echo json_encode($returnArray);
        return;
    
?>
