<?php
    // Use htmlentities to parse bad strings
    if  (isset($_REQUEST["sender"])) {
        $sender = htmlentities($_REQUEST["sender"]);
    } else {
        $sender = null;
    }
    if  (isset($_REQUEST["receiver"])) {
        $receiver = htmlentities($_REQUEST["receiver"]);
    } else {
        $receiver = null;
    }
 
    // Make sure all variables have value
    if (empty($sender) || empty($receiver)) {
        $returnArray["status"] = "400";
        $returnArray["message"] = "Missing required information";
        echo json_encode($returnArray);
        return;
    }

    require 'database.php';

    $stmt0 = $mysqli->prepare("SELECT user_id FROM users WHERE username=?");
    
    if (!$stmt0) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }

    $stmt0->bind_param('s', $sender);
    $stmt0->execute();

    $stmt0->bind_result($sender_id);
    $stmt0->fetch();
    $stmt0->close();

    $stmt1 = $mysqli->prepare("SELECT user_id FROM users WHERE username=?");
    
    if (!$stmt1) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }

    $stmt1->bind_param('s', $receiver);
    $stmt1->execute();

    $stmt1->bind_result($receiver_id);
    $stmt1->fetch();
    $stmt1->close();
    

    $stmt2 = $mysqli->prepare("SELECT status, initiater_id FROM connections WHERE member1_id=? AND member2_id=?");
    

    if (!$stmt2) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }


    $stmt2->bind_param('ss', $sender_id, $receiver_id);
    $stmt2->execute();

    $stmt2->bind_result($status, $initiater_id);
    $stmt2->fetch();
    $stmt2->close();

    if ($status == "BLOCKED") {
        $returnArray["status"] = "301";
        $returnArray["message"] = "Unable to friend this user";
        echo json_encode($returnArray);
    } else if ($status == "ACCEPTED") {
        $returnArray["status"] = "302";
        $returnArray["message"] = "You are already friends with this user";
        echo json_encode($returnArray);
    } else if ($status == "PENDING") { 
        if ($sender_id != $initiater_id) {
            $stmt3 = $mysqli->prepare("UPDATE connections SET status=? WHERE member1_id=? AND member2_id=?");
            if (!$stmt3) {
                printf("Query Prep Failed: %s\n", $mysqli->error);
            }

            $accepted = "ACCEPTED";
            $stmt3->bind_param('sss', $sender_id, $receiver_id, $accepted);
            $stmt3->execute();
            if ($stmt3) {
                $returnArray["status"] = "200";
                $returnArray["message"] = "Successfully accepted a pending friend request";
                echo json_encode($returnArray);
                return json_encode($returnArray);
            } else {
                $returnArray["status"] = "400";
                $returnArray["message"] = "Failed to accept friend request";
                echo json_encode($returnArray);
                return json_encode($returnArray);
            }   
            $stmt3->close(); 
        } else {
            $returnArray["status"] = "305";
            $returnArray["message"] = "You have already sent this person a friend request";
            echo json_encode($returnArray);
            return json_encode($returnArray);
        }
    } else {
       // Initiate the connection
        $stmt3 = $mysqli->prepare("INSERT INTO connections(member1_id, member2_id, status, initiater_id) VALUES(?, ?, ?, ?)");
        if (!$stmt3) {
            printf("Query Prep Failed: %s\n", $mysqli->error);
        }

        $pending = "PENDING";
        $stmt3->bind_param('ssss', $sender_id, $receiver_id, $pending, $sender_id);
        $stmt3->execute();
        if ($stmt3) {
            $returnArray["status"] = "200";
            $returnArray["message"] = "Set friend request status to pending";
            echo json_encode($returnArray);
            return json_encode($returnArray);
        } else {
            $returnArray["status"] = "400";
            $returnArray["message"] = "Failed to send friend request";
            echo json_encode($returnArray);
            return json_encode($returnArray);
        } 
        $stmt3->close();
    }
?>
