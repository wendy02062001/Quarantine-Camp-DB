<?php
    function display_table($headers, $data){
        echo '<table class="table table-striped table-bordered">';
        
        //display headers
        echo '<thead class="thead-inverse">';
        echo '<tr>';
        echo '<th scope="col" class="text-center">#</th>';
        foreach($headers as $header){
            echo sprintf('<th scope="col" class="text-center">%s</th>', ucwords(str_replace("_", " ", $header)));
        }
        echo '</tr>';
        echo '</thead>';


        //display the data
        echo '<tbody>';
        for($i = 0; $i < count($data); $i++){
            echo '<tr>';
            echo sprintf('<th scope="row" class="text-center">%d</th>', $i);

            foreach($headers as $key){
                echo sprintf('<td>%s</td>', $data[$i][$key]);
            }
            echo '</tr>';
        }

        echo '</tbody>';
        echo '</table>';
    }
?>



<?php
    $demographic_fields = [
        "patient_number",
        "full_name",
        "gender",
        "identity_number",
        "phone",
        "address"
    ];

    if (isset($_SESSION["medical_record"])){
        
        echo '<div class="report-container">';


        //display demographic information
        foreach ($demographic_fields as $key){
            echo '<div class = "row">';
            echo sprintf('<div class="col-xs-3 field-title">%s</div>', ucwords(str_replace("_", " ", $key)).":");
            echo sprintf('<div class="col-xs-9 field-value">%s</div>', $_SESSION["medical_record"][$key]);
            echo '</div>';
        }
        
        //display comorbidities
        echo '<div class = "row">';
        echo '<div class="col-xs-3 field-title">Comorbidities:</div>';
        
        if (isset($_SESSION["medical_record"]["comorbidities"])){
            $comorbidities = $_SESSION["medical_record"]["comorbidities"];
            echo sprintf('<div class="col-xs-9 field-value">%s</div>', $comorbidities? $comorbidities: "None");
        }else{
            echo '<div class="col-xs-9 field-value">None</div>';
        }
        echo '</div>';


        //display testing information
        if (isset($_SESSION["medical_record"]["testing_information"])){
            echo '<div class = "row">';
            echo '<div class="col-xs-3 field-title">Testing information:</div>';
            echo '</div>';

            $headers = [
                "test_time",
                "pcr_test_result",
                "pcr_test_ct_value",
                "quick_test_result",
                "quick_test_ct_value",
                "respiratory_rate",
                "spo2"
            ];
            echo '<div class = "table-wrapper">';
            display_table($headers, $_SESSION["medical_record"]["testing_information"]);
            echo '</div>';
        }


        //display symptoms
        if (isset($_SESSION["medical_record"]["symptoms"])){
            echo '<div class = "row">';
            echo '<div class="col-xs-3 field-title">Recorded symptoms:</div>';
            echo '</div>';

            $headers = [
                "check_time",
                "description"
            ];
            echo '<div class = "table-wrapper">';
            display_table($headers, $_SESSION["medical_record"]["symptoms"]);
            echo '</div>';
        }



        //display treatments
        if (isset($_SESSION["medical_record"]["treatments"])){
            echo '<div class = "row">';
            echo '<div class="col-xs-3 field-title">Treatments:</div>';
            echo '</div>';

            $headers = [
                "doctor_number",
                "doctor_full_name",
                "medication_code",
                "medication_name",
                "start_date",
                "end_date",
                "result"
            ];
            echo '<div class = "table-wrapper">';
            display_table($headers, $_SESSION["medical_record"]["treatments"]);
            echo '</div>';
        }

        echo '</div>';

        //isset will return FALSE if the variable = null
        $_SESSION["medical_record"] = null;
    }
?>


