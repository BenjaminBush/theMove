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
        $returnArray["status"] = "400";
        $returnArray["message"] = "Failed to prepare the first statement";
        echo json_encode($returnArray);
        return json_encode($returnArray);
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

    $stmt2 = $mysqli->prepare("INSERT INTO users(username, first_name, last_name, password, email) VALUES(?, ?, ?, ?, ?)");
    
    if (!$stmt2) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
        $returnArray["message"] = "Something went wrong with the insert";
        $returnArray["status"] = 400;
        echo json_encode($returnArray);
        return json_encode($returnArray);
    }

    $encrypted_pass = password_hash($password, PASSWORD_BCRYPT);
	

    $stmt2->bind_param('sssss', $username, $firstname, $lastname, $encrypted_pass, $email);
    $stmt2->execute();
    if ($stmt2) {
        $returnArray["status"] = "200";
        $returnArray["message"] = "OK";
        $returnArray["username"] = $username;
        $returnArray["first_name"] = $firstname;
        $returnArray["last_name"] = $lastname;
        $returnArray["email"] = $email;


        $stmt3 = $mysqli->prepare("SELECT user_id FROM users WHERE username=?");
        if (!$stmt3) {
            printf("Query Prep Failed: %s\n", $mysqli->error);
            $returnArray["status"] = "400";
            $returnArray["messagae"] = "Something wrong with getting the id";
            echo json_encode($returnArray);
            return json_encode($returnArray);

        }
        $stmt3->bind_param('s', $username);
        $stmt3->execute();

        $stmt3->bind_result($user_id);
        $stmt3->fetch();

        $returnArray["user_id"] = $user_id;
        echo json_encode($returnArray);
        return json_encode($returnArray);
    } else {
	$returnArray["status"] = "400";
	$returnArray["message"] = "Failed to insert user into the database";
	echo json_encode($returnArray);
	return json_encode($returnArray);
    } 
?>
