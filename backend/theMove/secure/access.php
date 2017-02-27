<?php
    /**
     * Created by PhpStorm.
     * User: benbush
     * Date: 2/18/17
     * Time: 1:14 PM
     */
    
    // Declare class to access this php file
    class access {
        
        // Connection global variables
        var $host = null;
        var $user = null;
        var $pass = null;
        var $name = null;
        var $conn = null;
        var $result = null;
        
        
        // Constructor
        function __construct($dbhost, $dbuser, $dbpass, $dbname)
        {
            $this->host = $dbhost;
            $this->user = $dbuser;
            $this->pass = $dbpass;
            $this->name = $dbname;
        }
        
        // Connection function
        public function connect() {
            $this->conn = new mysqli($this->host, $this->user, $this->pass, $this->name);
            
            if (mysqli_connect_errno()) {
                printf("Connection Failed: %s\n", $this->conn->connect_errno);
            } else {
                echo "Connected";
            }
            
            $this->conn->set_charset("utf8");
        }
        
        
        // Disconnect function
        public function disconnect() {
            if ($this->conn != null) {
                $this->conn->close();
            }
        }
        
    }
    
    
    
    ?>