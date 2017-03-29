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
    $firstname = htmlentities($_REQUEST["firstname"]);
    $lastname = htmlentities($_REQUEST["lastname"]);

 
    // Make sure all variables have value
    if (empty($username) || empty($password) || empty($email) || empty($firstname) || empty($lastname)) {
        $returnArray["status"] = "400";
        $returnArray["message"] = "Missing required information";
        echo json_encode($returnArray);
        return;
    }

    require 'database.php';
    $stmt = $mysqli->prepare("SELECT user_id, username, first_name, last_name FROM users");
    if (!$stmt) {
	printf("Query Prep Failed: %s\n", $mysqli->error);
	exit;
    }

    $stmt->execute();
    $result = $stmt->get_result();
    while($row = $result->fetch_assoc()) {
        if($row['username'] == $username) {
	    $returnArray["status"] = "400";
	    $returnArray["message"] = "Username already taken, please choose a different username";
	    echo json_encode($returnArray);
            return;
        }
    }

    $stmt2 = $mysqli->prepare("INSERT INTO users(username, first_name, last_name, password) VALUES(?, ?, ?, ?)");
    
    if (!$stmt2) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }

    $encrypted_pass = crypt($password);
	

    $stmt2->bind_param('ssss', $username, $firstname, $lastname, $encrypted_pass);
    $stmt2->execute();
    if ($stmt2) {
        $returnArray["status"] = "200";
        $returnArray["message"] = "OK";
        $returnArray["username"] = $username;
        $returnArray["first_name"] = $firstname;
        $returnArray["last_name"] = $lastname;
        echo json_encode($returnArray);
        return json_encode($returnArray);
    } else {
	$returnArray["status"] = "400";
	$returnArray["message"] = "Failed to insert user into the database";
	echo json_encode($returnArray);
	return json_encode($returnArray);
    } 
?>
