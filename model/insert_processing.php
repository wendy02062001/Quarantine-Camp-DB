<?php
    require_once(dirname(__FILE__) . "/../settings.php");

    session_start();

    if (!isset($_SESSION["alerts"])){
        $_SESSION["alerts"] = array();
    }


    //array of non-nullable attributes
    //the attributes of which value is 1 must be but in quotes
    $params = array(
        "full_name" => 1,
        "gender" => 1,
        "identity_number" => 1,
        "phone" => 1,
        "address" => 1,
        "patient_status" => 1,
        "admitting_staff" => 0,
        "admission_date" => 1,
        "last_location" => 1,
        "nurse_number" => 0,
        "room_number"  => 0,
        "floor_number"  => 0,
        "building_number"  => 0,
        "camp_number" => 0
    );


    if (isset($_SESSION["username"])){
        //logged in
        $columns = "(";    //the columns to be inserted
        $values = "(";     //the corresponding values of these columns
        

        foreach(array_keys($params) as $key){
            if (isset($_POST[$key])){
                if ($_POST[$key]){
                    $columns .= sprintf("%s, ", $key);

                    if ($params[$key]){
                        //put quotes around datatypes such as varchar, date, char, ...
                        $values .= sprintf("'%s', ", $_POST[$key]);
                    }else{
                        $values .= sprintf("%s, ", $_POST[$key]);
                    }
                }else{
                    //a non-nullable field is not provided
                    array_push($_SESSION["alerts"], array(
                        "alert-type" => "alert-danger",
                        "message"=> "Please provide all required parameters."
                    ));
                    
        
                    header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=insert");
                    exit;
                }                   
            }else{
                //a non-nullable field is not provided
                array_push($_SESSION["alerts"], array(
                    "alert-type" => "alert-danger",
                    "message"=> "Please provide all required parameters."
                ));
                
    
                header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=insert");
                exit;
            }
        }


        if (isset($_POST["discharge_date"])){
            if ($_POST["discharge_date"]){
                $columns .= "discharge_date";
                $values .= $_POST["discharge_date"];
            }
        }

        $columns = rtrim($columns, ", ") . ")";
        $values = rtrim($values, ", ") . ")";


        $query_str = sprintf('INSERT INTO patient %s VALUES %s;', $columns, $values);

        echo $query_str;
        $conn = mysqli_connect($MYSQL_SERVERNAME, $_SESSION["username"], $_SESSION["password"], $MYSQL_DBNAME);


        if (!$conn){
            //cannot open connection
            array_push($_SESSION["alerts"], array(
                "alert-type" => "alert-danger",
                "message"=> "<strong>Error!</strong> Error connecting to the DB: ".mysqli_connect_error()."."
            ));


            header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=insert");
            exit;
        }


        if (!mysqli_query($conn, $query_str)){
            //query failed
            array_push($_SESSION["alerts"], array(
                "alert-type" => "alert-danger",
                "message"=> "<strong>Error!</strong> Error inserting record: ".mysqli_error($conn)."."
            ));

            header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=insert");
            exit;
        }


        //add comorbidities
        if (isset($_POST["comorbidities"])){
            if ($_POST["comorbidities"]){
                $patient_number = mysqli_insert_id($conn);
                $query_str = "INSERT INTO comorbidity (patient_number, name) VALUES ";
                $comorbidities = explode(",", $_POST["comorbidities"]);
                
                foreach($comorbidities as $comorbidity){
                    $query_str .= sprintf("(%s, '%s'), ", $patient_number, trim($comorbidity, " "));
                }

                $query_str = rtrim($query_str, ", ") . ";";

                if (!mysqli_query($conn, $query_str)){
                    array_push($_SESSION["alerts"], array(
                        "alert-type" => "alert-danger",
                        "message"=> "<strong>Error!</strong> Error inserting record: ".mysqli_error($conn)."."
                    ));

                    header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=insert");
                    exit;
                }
            }
        }

        
        array_push($_SESSION["alerts"], array(
            "alert-type" => "alert-success",
            "message"=> "<strong>Success!</strong> Successfully inserted new patient record."
        ));


        mysqli_close($conn);

    }else{

        //not logged in
        array_push($_SESSION["alerts"], array(
            "alert-type" => "alert-danger",
            "message"=> "Please provide all required parameters."
        ));

        header("Location: ".$ABS_ROOT_PATH."/index.php?page=home");
        exit;
    }


    header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=insert");
    exit;

?>