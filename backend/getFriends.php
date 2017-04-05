<?php
    /**
     * Created by PhpStorm.
     * User: MaraEvans
     * Date: 3/29/17
     * Time: 1:33 PM
     */
    // Use htmlentities to parse bad strings
    require 'database.php';
    $current_user = intval($_REQUEST["user_id"]);
    $stmt = $mysqli->prepare("SELECT users.first_name, users.last_name, users.username, connections.status FROM connections INNER JOIN users ON connections.member1_id = $current_user WHERE connections.member2_id = users.user_id");
    if (!$stmt) {
       printf("Query Prep Failed: %s\n", $mysqli->error);
       exit;
    }
    $stmt->execute();
    $result = $stmt->get_result();
    $num_friends = $result->num_rows;
    $index = 0;

    if ($num_friends == 0) {
            $returnArray["status"] = "0";
            $returnArray["message"] = "No friends found in first column.";
            // echo json_encode($returnArray);
            // return;
    }
    else{
        $returnArray["status"] = "1";
        $returnArray["message"] = "Loaded friends1 successfully!";
        $returnArray["num_friends"] = $num_friends2;
        // $index = 0;
        while($row = $result2->fetch_assoc()) {
            $returnArray[$index]["first_name"]= $row["first_name"];
            $returnArray[$index]["last_name"] = $row["last_name"];
            $returnArray[$index]["username"] = $row["username"];
            $returnArray[$index]["status"] = $row["status"];
            $index += 1;
        }
    // echo json_encode($returnArray);
    //     return;
    }




    //if ($num_friends == 0) {
        
    $stmt2 = $mysqli->prepare("SELECT users.first_name, users.last_name, users.username, connections.status FROM connections INNER JOIN users ON connections.member2_id = $current_user WHERE connections.member1_id = users.user_id");
    if (!$stmt2) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
        exit;
    }
    $stmt2->execute();
    $result2 = $stmt2->get_result();
    $num_friends2 = $result2->num_rows;
    if ($num_friends2 == 0) {
        $returnArray["status"] = "0";
        $returnArray["message"] = "No friends found in second column.";
        // echo json_encode($returnArray);
        // return;
    }
    else{
        $returnArray["status"] = "1";
        $returnArray["message"] = "Loaded friends2 successfully!";
        $returnArray["num_friends"] = $num_friends2;
        // $index = 0;
        while($row = $result2->fetch_assoc()) {
            $returnArray[$index]["first_name"]= $row["first_name"];
            $returnArray[$index]["last_name"] = $row["last_name"];
            $returnArray[$index]["username"] = $row["username"];
            $returnArray[$index]["status"] = $row["status"];
            $index += 1;
        }
        echo json_encode($returnArray);
        return;
    }
//}
    if ($num_friends == 0 && $num_friends2 == 0){
        $returnArray["status"] = "0";
        $returnArray["message"] = "No friends found.  Add some!";
    }
    echo json_encode($returnArray);
    return;    
?>
