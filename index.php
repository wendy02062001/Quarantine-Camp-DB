<?php
    require_once("settings.php");
    session_start();

    $_SESSION["active_page"] = "home";

    if (isset($_GET["page"])){
        if (in_array($_GET["page"], $PAGES)){
            $_SESSION["active_page"] = $_GET["page"];
        }
    }

    if ($_SESSION["active_page"] === "home" && isset($_SESSION["username"])){
        //if user is logged in
        if (isset($_GET["query_option"])){
            if (in_array($_GET["query_option"], $QUERY_OPTIONS)){
                $_SESSION["active_page"] = "home_".$_GET["query_option"];
            }else{
                $_SESSION["active_page"] = "home_search";
            }
        }else{
            $_SESSION["active_page"] = "home_search";
        }
    }

?>


<!DOCTYPE html>
<html>
    <head>
        <title>Quarantine Camp MS</title>


        <meta charset = "UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        
        <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.0.min.js"></script><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">  
     
        <link rel="stylesheet" type="text/css" href= "<?= $ABS_ROOT_PATH?>/styles/index.css">
    </head>


    <body>
        <!--navigation_bar-->
        <?php
            require(dirname(__FILE__) . "/templates/navbar.php");
        ?>
        
        <!-- main body -->
        <div class="wrapper">

            <!-- display alerts -->
            <?php
                if (isset($_SESSION["alerts"])){
                    foreach($_SESSION["alerts"] as $alert){
                        echo sprintf('
                            <div class="alert alert-dismissible %s fade in">
                                <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                                %s
                            </div>
                        ', $alert["alert-type"], $alert["message"]);
                    }

                    $_SESSION["alerts"] = array();
                }
            ?>


            <!-- page's content -->
            <div class="page-container">
                <?php
                    require("routes/".$_SESSION["active_page"].".php");
                ?>
            </div>
        </div>
        

        <script>
                $(document).ready(function () {
    
                window.setTimeout(function() {
                    $(".alert").fadeTo(2000, 500).slideUp(500, function(){
                        $(this).remove(); 
                    });
                }, 1000);
                
                });
        </script>  
    </body>


</html>