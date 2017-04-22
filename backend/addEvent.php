<?php
    /**
     * Created by PhpStorm.
     * User: benbush
     * Date: 2/18/17
     * Time: 1:33 PM
     */
    // Use htmlentities to parse bad strings
    $host = htmlentities($_REQUEST["host"]);
    $name = htmlentities($_REQUEST["name"]);
    $date = htmlentities($_REQUEST["date"]);
    $addr = htmlentities($_REQUEST["address"]);
    $numGuests = 0;
    $active = htmlentities($_REQUEST["active"]);
    $event_id = 0;

 
    // Make sure all variables have value
    if (empty($host) || empty($name) || empty($date) || empty($addr) || !isset($active)) {
        $returnArray["status"] = "400";
        $returnArray["message"] = "Missing required information";
        echo json_encode($returnArray);
        return;
    }

    require 'database.php';

    $stmt0 = $mysqli->prepare("SELECT user_id FROM users WHERE username=?");
    if (!$stmt0) {
    printf("Query Prep Failed: %s\n", $mysqli->error);
    exit;
    }

    $stmt0->bind_param('s', $host);
    $stmt0->execute();

    $stmt0->bind_result($host_id);
    $stmt0->fetch();
    $stmt0->close();

    $stmt = $mysqli->prepare("INSERT INTO events(host_id, event_name, event_date, event_address, numGuests, active) VALUES(?, ?, ?, ?, ?, ?)");
    

    if (!$stmt) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }

    $stmt->bind_param('isssii', $host_id, $name, $date, $addr, $numGuests, $active);
    $stmt->execute();
    //$event_id = mysql_insert_id();
    //$returnArray["last_event"] = $event_id;
    
    
   
    if ($stmt) {
        $returnArray["status"] = "200";
        $returnArray["message"] = "OK";
        //echo json_encode($returnArray);
        //return json_encode($returnArray);
    } else {
        $returnArray["status"] = "400";
        $returnArray["message"] = "Failed to insert event into the database";
        echo json_encode($returnArray);
        return json_encode($returnArray);
    } 
    $stmt->close();
    
    $getID = $mysqli->prepare("SELECT MAX(event_id) from events");
    if (!$getID) {
            printf("Delete query Prep Failed: %s\n", $mysqli->error);
        }
    $getID->execute();
    $getID->bind_result($event_id);
    $getID->fetch();
    $getID->close();
    
    $returnArray["last_event"] = $event_id;
    
    if ($returnArray["status"] == "200") {
        $checkDelete = $mysqli-> prepare("DELETE from guests where guest_id = ? and event_id in (SELECT event_id from events where active = 1)");
        if (!$checkDelete) {
            printf("Delete query Prep Failed: %s\n", $mysqli->error);
        }
        $checkDelete->bind_param('i', $host_id);
        $checkDelete->execute();
        if (!$checkDelete) {
            $returnArray["status"] = "400";
            $returnArray["message"] = "Failed to insert event into the database";
            echo json_encode($returnArray);
            return json_encode($returnArray);
        }
        $checkDelete->close();
    
        $stmt2 = $mysqli->prepare("INSERT into guests(event_id, guest_id) VALUES (?,?)");
        if (!$stmt2) {
            printf("Query Prep to insert host Failed: %s\n", $mysqli->error);
         exit;
         }
        $stmt2->bind_param('ii', $event_id, $host_id);
        $stmt2->execute(); 
        if ($stmt2) {
            echo json_encode($returnArray);
            return json_encode($returnArray);
        }
        $stmt2->close();
    }
?>
