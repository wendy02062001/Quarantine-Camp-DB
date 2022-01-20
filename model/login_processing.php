<?php
    require_once(dirname(__FILE__) . "/../settings.php");

    session_start();

    if (!isset($_SESSION["alerts"])){
        $_SESSION["alerts"] = array();
    }

    $redirect = "login";

    if (isset($_SESSION["username"])){
        //already logged in
        array_push($_SESSION["alerts"], array(
            "alert-type"=> "alert-info",
            "message"=> "You have already logged in.. Please log out before logging in with a different account."
        ));

        $redirect = "home";

    }else{
        //not logged in
        if (isset($_POST["username"]) && isset($_POST["password"])){
            //check credentials
            $username = $_POST["username"];
            $password = $_POST["password"];

            $conn = mysqli_connect($MYSQL_SERVERNAME, $username, $password, $MYSQL_DBNAME);

            if ($conn){
                array_push($_SESSION["alerts"], array(
                    "alert-type"=> "alert-success",
                    "message"=> "<strong>Success!</strong> Successfully connected to DB as ".$username."."
                ));
                
                $_SESSION["username"] = $username;
                $_SESSION["password"] = $password;
                $redirect = "home";

                mysqli_close($conn);
                
            }else{
                array_push($_SESSION["alerts"], array(
                    "alert-type"=> "alert-danger",
                    "message" => "<strong>Error!</strong> ".mysqli_connect_error()."."
                ));
            }
        }else{
            array_push($_SESSION["alerts"], array(
                "alert-type"=> "alert-danger",
                "message" => "<strong>Error!</strong> Insufficient credentials."
            ));
        }
    }


    header("Location: ".$ABS_ROOT_PATH."/index.php?page=".$redirect);
    exit;
?>

