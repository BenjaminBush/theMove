<?php
    /**
     * Created by PhpStorm.
     * User: benbush
     * Date: 2/18/17
     * Time: 1:33 PM
     */
    // Use htmlentities to parse bad strings
    $event_id = htmlentities($_REQUEST["event_id"]);
 
    // Make sure all variables have value
    if (empty($event_id)) {
        $returnArray["status"] = "400";
        $returnArray["message"] = "Missing required information";
        echo json_encode($returnArray);
        return;
    }

    require 'database.php';


    $stmt = $mysqli->prepare("DELETE FROM events WHERE event_id='$event_id'");
    

    if (!$stmt) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }

    $stmt->execute();

    if ($stmt) {
        $returnArray["status"] = "200";
        $returnArray["message"] = "OK";
        echo json_encode($returnArray);
        return json_encode($returnArray);
    } else {
        $returnArray["status"] = "400";
        $returnArray["message"] = "Failed to insert user into the database";
        echo json_encode($returnArray);
        return json_encode($returnArray);
    } 
    $stmt->close();
?>
