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

    // Crypt the password
    // $salt = openssl_random_pseudo_bytes(20);
    // $secured_pass = sha1($password.$salt);
    
    // Build connection
    $file = parse_ini_file("../../../theMove.ini");
    $host = trim($file["dbhost"]);
    $user = trim($file["dbuser"]);
    $pass = trim($file["dbpass"]);
    $name = trim($file["dbname"]);
    
    require ("secure/access.php");
    $access = new access($host, $user, $pass, $name);
    $access->connect();
    
    $stmt = $access->conn->prepare("SELECT COUNT(*) FROM users");

    if (!$stmt) {
        printf("Query Prep Failed: %s\n", $access->conn->error);
        exit;
    }

    $stmt->execute();
    $result = $access->conn->get_result();
    while($row = $result->fetch_assoc()){
        if($row['username'] == $username){
            // Username already exists
            header("Location: failure.php");
        }
    }
    #If the user already exists
    if(isset($_GET['invalid'])){
        echo "Sorry, username already exists. Please enter another.";
    }


    ?>