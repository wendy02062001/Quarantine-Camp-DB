<?php
    require_once(dirname(__FILE__) . "/../settings.php");

    session_start();

    if (!isset($_SESSION["alerts"])){
        $_SESSION["alerts"] = array();
    }


    $params = [
        "patient_number" => 0,
        "full_name" => 1, 
        "phone" => 1,
        "identity_number" => 1,
        "admission_date" => 1
    ];


    $report_types = ["general", "testing", "full"];

    
    if (isset($_SESSION["username"])){
        //logged in
        $query_str = "SELECT * FROM patient WHERE ";

        
        foreach(array_keys($params) as $key){
            if (isset($_POST[$key])){
                if ($_POST[$key]){
                    if ($params[$key]){
                        //paramaters of type varchar, char, date, ... should be put in quotes
                        $query_str .= sprintf("(%s = '%s') AND ", $key, $_POST[$key]);
                    }else{
                        $query_str .= sprintf("(%s = %s) AND ", $key, $_POST[$key]);
                    }
                }
            }
        }

        if (strlen($query_str) == 28){
            //no condition added to the query
            array_push($_SESSION["alerts"], array(
                "alert-type"=> "alert-danger",
                "message"=> "Please provide at least one paramater to identify the patient."
            ));

            header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=search");
            exit;
        }


        $query_str = rtrim($query_str, "AND ") . ";";
        $conn = mysqli_connect($MYSQL_SERVERNAME, $_SESSION["username"], $_SESSION["password"], $MYSQL_DBNAME);
        $query = mysqli_query($conn, $query_str);

        if (!$query){
            array_push($_SESSION["alerts"], array(
                "alert-type"=> "alert-danger",
                "message"=> "Error selecting from DB: ".mysqli_error($conn)."."
            ));

            header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=search");
            exit;
        }



        if (mysqli_num_rows($query) != 1){
            //insufficient information
            if (mysqli_num_rows($query) == 0){
                array_push($_SESSION["alerts"], array(
                    "alert-type"=> "alert-danger",
                    "message"=> "This patient does not exist."
                ));
            }else{
                array_push($_SESSION["alerts"], array(
                    "alert-type"=> "alert-danger",
                    "message"=> "Cannot identify the patient due to insufficient information."
                ));
            }

            header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=search");
            exit;
        }

        //retrieve demographic information
        $record = mysqli_fetch_assoc($query);


        //retrieve comorbidities (seperated by comma)
        $patient_number = $record["patient_number"];
        $comorbidities = "";

        $query_str = sprintf("SELECT name FROM comorbidity WHERE patient_number = %s;", $patient_number);
        $query = mysqli_query($conn, $query_str);

        while($row = mysqli_fetch_assoc($query)){
            $comorbidities .= ($row["name"].", ");
        }

        $comorbidities = rtrim($comorbidities, ", ");
        $record["comorbidities"] = $comorbidities;


        //retrieve additional information (based on type of report)
        //if type of report not provided, default is general
        if (!isset($_POST["report_type"])){
            $_SESSION["medical_record"] = $record;

            header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=search");
            exit;
        }

        if (!in_array($_POST["report_type"], $report_types)){
            $_POST["report_type"] = "general";
        }


        if ($_POST["report_type"] == "general"){
            $_SESSION["medical_record"] = $record;

            header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=search");
            exit;
        }


        //retrieve testing information
        $query_str = sprintf("SELECT
        test_time,
        pcr_test_result,
        pcr_test_ct_value,
        quick_test_result,
        quick_test_ct_value,
        respiratory_rate,
        spo2
        FROM testing_information
        WHERE patient_number = %s;", $patient_number);
        

        $query = mysqli_query($conn, $query_str);

        if (!$query){
            array_push($_SESSION["alerts"], array(
                "alert-type"=> "alert-danger",
                "message"=> "Error selecting from DB: ".mysqli_error($conn)."."
            ));

            header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=search");
            exit;
        }


        $testing_information = array();

        while($row = mysqli_fetch_assoc($query)){
            array_push($testing_information, $row);
        }

        $record["testing_information"] = $testing_information;


        if ($_POST["report_type"] == "testing"){
            $_SESSION["medical_record"] = $record;

            header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=search");
            exit;
        }


        //retrieve symptoms
        $query_str = sprintf("SELECT check_time, description FROM symptom WHERE patient_number = %s;", $patient_number);
        $query = mysqli_query($conn, $query_str);

        if (!$query){
            array_push($_SESSION["alerts"], array(
                "alert-type"=> "alert-danger",
                "message"=> "Error selecting from DB: ".mysqli_error($conn)."."
            ));

            header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=search");
            exit;
        }

        $symptoms = array();

        while ($row = mysqli_fetch_assoc($query)){
            array_push($symptoms, $row);
        }

        $record["symptoms"] = $symptoms;


        //retreive treatments
        $query_str = "SELECT
        doctor_number,
        doctor.full_name AS doctor_full_name,
        medication_code,
        medication.name AS medication_name,
        start_date,
        end_date,
        result
        FROM (
            (treatment JOIN doctor ON doctor_number = doctor.personnel_number)
            JOIN medication ON medication_code = medication.code
        )
        WHERE patient_number = " . $patient_number . ";";

        $query = mysqli_query($conn, $query_str);

        if (!$query){
            array_push($_SESSION["alerts"], array(
                "alert-type"=> "alert-danger",
                "message"=> "Error selecting from DB: ".mysqli_error($conn)."."
            ));

            header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=search");
            exit;
        }

        $treatments = array();

        while($row = mysqli_fetch_assoc($query)){
            array_push($treatments, $row);
        }

        $record["treatments"] = $treatments;
        $_SESSION["medical_record"] = $record;


        header("Location: ".$ABS_ROOT_PATH."/index.php?page=home&query_option=search");
        exit;
        
    }else{
        //not logged in
        array_push($_SESSION["alerts"], array(
            "alert-type"=> "alert-danger",
            "message"=> "You are not logged in. Please log in to use the MS."
        ));

        header("Location: ".$ABS_ROOT_PATH."/index.php?page=home");
        exit;
    }    
?>