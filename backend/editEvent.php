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
    $active = htmlentities($_REQUEST["active"]);
    $event_id = htmlentities($_REQUEST["event_id"]);
 
    // Make sure all variables have value
    if (empty($event_id) ||  empty($host) || empty($name) || empty($date) || empty($addr) || !isset($active)) {
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

    $stmt = $mysqli->prepare("UPDATE events SET host_id='$host_id', event_name='$name', event_date='$date', event_address='$addr', active='$active' WHERE event_id='$event_id'");
    

    if (!$stmt) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }

    #$stmt->bind_param('isssii', $host_id, $name, $date, $addr, $active, $event_id);
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
