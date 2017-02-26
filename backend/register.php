<?php
    /**
     * Created by PhpStorm.
     * User: benbush
     * Date: 2/18/17
     * Time: 1:33 PM
     */
    // Use htmlentities to parse bad strings
    $username = htmlentities($_REQUEST["username"]);
    $password = htmlentities($_REQUEST["password"]);
    $email = htmlentities($_REQUEST["email"]);
    $fullname = htmlentities($_REQUEST["fullname"]);

 
    // Make sure all variables have value
    if (empty($username) || empty($password) || empty($email) || empty($fullname)) {
        $returnArray["status"] = "400";
        $returnArray["message"] = "Missing required information";
        echo json_encode($returnArray);
        return;
    }

    require 'database.php';
    $stmt = $mysqli->prepare("SELECT COUNT(*) FROM users");
    if (!$stmt) {
	printf("Query Prep Failed: %s\n", $mysqli->error);
	exit;
    }

    $stmt->execute();
    $result = $mysqli->get_result();
    while($row = $result->fetch_assoc()) {
        if($row['username'] == $username) {
            header("Location: failure.php");
        }
    }

    $stmt2 = $mysqli->prepare("INSERT INTO users(username, first_name, last_name, password) VALUES(?, ?, ?, ?)");
    
    if (!$stmt2) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }

    $encrypted_pass = crypt($password);
	
    $last = "Smith";

    $stmt2->bind_param('ssss', $username, $fullname, $last, $encrypted_pass);
    $stmt2->execute();
    if ($stmt2) {
        $returnArray["status"] = "200";
	$returnArray["message"] = "OK";
	echo json_encode($returnArray);
    } else {
	$returnArray["status"] = "400";
	$returnArray["message"] = "Failed to insert user into the database";
	echo json_encode($returnArray);
    }
    
    
    ?>
