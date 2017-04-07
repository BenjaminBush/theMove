<?php
    /**
     * Created by PhpStorm.
     * User: benbush
     * Date: 2/18/17
     * Time: 1:33 PM
     */
    // Use htmlentities to parse bad strings
    $username = htmlentities($_REQUEST["username"]);

 
    // Make sure all variables have value
    if (empty($username)) {
        $returnArray["status"] = "400";
        $returnArray["message"] = "Missing required information";
        echo json_encode($returnArray);
        return;
    }

    require 'database.php';

    $stmt = $mysqli->prepare("SELECT username, password, user_id, first_name, last_name, email FROM users WHERE username=?");
    

    if (!$stmt) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }


    $stmt->bind_param('s', $username);
    $stmt->execute();

    $stmt->bind_result($user, $pass, $id, $first, $last, $email);
    $stmt->fetch();

    $returnArray["status"] = "200";
    $returnArray["message"] = "LogGet Info Successful";
    $returnArray["user_id"] = $id;
    $returnArray["username"] = $username;
    $returnArray["first_name"] = $first;
    $returnArray["last_name"] = $last;
    $returnArray["email"] = $email;
    echo json_encode($returnArray);
?>
