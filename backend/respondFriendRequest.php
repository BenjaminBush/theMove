<?php
    // Use htmlentities to parse bad strings
    $sender = htmlentities($_REQUEST["sender"]);
    $receiver = htmlentities($_REQUEST["receiver"]);
    $response = htmlentities($_REQUEST["response"]);

 
    // Make sure all variables have value
    if (empty($sender) || empty($receiver) || empty($response)) {
        $returnArray["status"] = "400";
        $returnArray["message"] = "Missing required information";
        echo json_encode($returnArray);
        return;
    }

    require 'database.php';

    $stmt = $mysqli->prepare("SELECT member1_id, member2_id, status FROM connections WHERE member1_id=? AND member2_id=?");
    

    if (!$stmt) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }


    $stmt->bind_param('ss', $sender, $receiver);
    $stmt->execute();

    $stmt->bind_result($mem1_id, $mem2_id, $status);
    $stmt->fetch();
    $stmt->close();
    if ($status == "ACCEPTED") {
        $returnArray["status"] = "302";
        $returnArray["message"] = "You are already friends with this user";
        echo json_encode($returnArray);
    } else if ($status == "PENDING") { 
        $stmt2 = $mysqli->prepare("UPDATE connections SET member1_id, member2_id, status VALUES(?, ?, ?)");
        if (!$stmt2) {
            printf("Query Prep Failed: %s\n", $mysqli->error);
        }

        $stmt2->bind_param('sss', $mem1_id, $mem2_id, $response);
        $stmt2->execute();
        if ($stmt2) {
            $returnArray["status"] = "200";
            $returnArray["message"] = "OK";
            echo json_encode($returnArray);
            return json_encode($returnArray);
        } else {
            $returnArray["status"] = "400";
            $returnArray["message"] = "Failed to accept friend request";
            echo json_encode($returnArray);
            return json_encode($returnArray);
        }  
        $stmt2->close();       
    } else {
        $returnArray["status"] = "400";
        $returnArray["message"] = "Something else went wrong";
        echo json_encode($returnArray);
        return json_encode($returnArray);
    }
?>