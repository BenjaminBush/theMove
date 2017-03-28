<?php
    // Use htmlentities to parse bad strings
    if  (isset($_REQUEST["initiater"])) {
        $initiater = htmlentities($_REQUEST["initiater"]);
    } else {
        $initiater = null;
    }
    if  (isset($_REQUEST["responder"])) {
        $responder = htmlentities($_REQUEST["responder"]);
    } else {
        $responder = null;
    }
    if  (isset($_REQUEST["response"])) {
        $response = htmlentities($_REQUEST["response"]);
    } else {
        $response = null;
    }
 
    // Make sure all variables have value
    if (empty($responder) || empty($initiater) || empty($response)) {
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

    $stmt0->bind_param('s', $responder);
    $stmt0->execute();

    $stmt0->bind_result($responder_id);
    $stmt0->fetch();
    $stmt0->close();

    $stmt1 = $mysqli->prepare("SELECT user_id FROM users WHERE username=?");
    
    if (!$stmt1) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }

    $stmt1->bind_param('s', $initiater);
    $stmt1->execute();

    $stmt1->bind_result($initiater_id);
    $stmt1->fetch();
    $stmt1->close();

    $stmt2 = $mysqli->prepare("SELECT status FROM connections WHERE member1_id=? AND member2_id=?");
    

    if (!$stmt2) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }


    $stmt2->bind_param('ss', $initiater_id, $responder_id);
    $stmt2->execute();

    $stmt2->bind_result($status);
    $stmt2->fetch();
    $stmt2->close();
    if ($status == "ACCEPTED") {
        $returnArray["status"] = "302";
        $returnArray["message"] = "You are already friends with this user";
        echo json_encode($returnArray);
    } else if ($status == "PENDING") { 
        $stmt3 = $mysqli->prepare("UPDATE connections SET status=? WHERE member1_id=? AND member2_id=? AND initiater_id=?");
        if (!$stmt3) {
            printf("Query Prep Failed: %s\n", $mysqli->error);
        }

        $stmt3->bind_param('ssss', $response, $initiater_id, $responder_id, $initiater_id);
        $stmt3->execute();
        if ($stmt3) {
            $returnArray["status"] = "200";
            $returnArray["message"] = "Successfully updated friend status";
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
        $returnArray["status"] = "400";
        $returnArray["message"] = "Something else went wrong";
        echo json_encode($returnArray);
        return json_encode($returnArray);
    }
?>
