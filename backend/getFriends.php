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
    $stmt = $mysqli->prepare("SELECT users.first_name, users.last_name, users.username, connections.status FROM connections INNER JOIN users ON connections.member1_id = $current_user AND connections.member2_id = users.user_id");
    if (!$stmt) {
	printf("Query Prep Failed: %s\n", $mysqli->error);
	exit;
    }
    $stmt->execute();
    $result = $stmt->get_result();
    $num_friends = $result->num_rows;
    if ($num_friends == 0) {
        $returnArray["status"] = "0";
        $returnArray["message"] = "No friends found. Add some!";
        echo json_encode($returnArray);
        return;
    }
        $returnArray["status"] = "1";
        $returnArray["message"] = "Loaded friends successfully!";
        $returnArray["num_friends"] = $num_friends;
        $index = 0;
    while($row = $result->fetch_assoc()) {
        $returnArray[$index]["first_name"]= $row["first_name"];
        $returnArray[$index]["last_name"] = $row["last_name"];
        $returnArray[$index]["username"] = $row["username"];
        $returnArray[$index]["status"] = $row["status"];
        $index += 1;
        }
        echo json_encode($returnArray);
        return;
    // $stmt->execute();
    // $result = $stmt->get_result();
    // $num_friends = $result->num_rows;
    // if ($num_friends == 0) {
    //     $returnArray["status"] = "0";
    //     $returnArray["message"] = "No friends. Add some!";
    //     echo json_encode($returnArray);
    //     return;
    // }
    //     $returnArray["status"] = "1";
    //     $returnArray["message"] = "Loaded friends successfully!";
    //     $returnArray["num_friends"] = $num_friends;
    //     $index = 0;

    // while($row = $result->fetch_assoc()) {
    //     $returnArray[$index]["member2_id"] = $row["member2_id"];
    //     $returnArray[$index]["status"] = $row["status"];
    //     $index += 1;
    //     echo json_encode($returnArray);
    // }

    // $returnArrayFinal["status"] = "1";
    // $returnArrayFinal["message"] = "Getting friend names";
    // $returnArrayFinal["num_friends"] = $num_friends;

    // for( $i = 0; $i<$num_friends; $i++ ) {
    //     $stmt2 = $mysqli->prepare("SELECT username, first_name, last_name FROM users where member2_id = $returnArray[$i]['member2_id']");  
    //     $stmt2->execute();
    //     $result2 = $stmt2->get_result();
    //     echo json_encode($result2);
    // }
            
    //return;
    
?>
