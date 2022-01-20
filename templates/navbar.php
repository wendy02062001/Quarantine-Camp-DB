<?php
    $login = isset($_SESSION["username"]);
?>




<nav class="navbar navbar-inverse">
    <div id="navbar-container" class="container-fluid">
        <div class="navbar-header">
        <a class="navbar-brand" href="<?= $ABS_ROOT_PATH ?>/index.php">Quarantine Camp MS</a>
        </div>
        

        <ul class="nav navbar-nav">
            <?php
                foreach($NAV_PAGES as $page){
                    if ($page == $_SESSION["active_page"]){
                        echo sprintf('<li><a class="active" href="%s">%s</a></li>',
                            $ABS_ROOT_PATH."/index.php?page=".$page,
                            ucfirst($page));
                    }else{
                        echo sprintf('<li><a href="%s">%s</a></li>',
                            $ABS_ROOT_PATH."/index.php?page=".$page,
                            ucfirst($page));
                    }
                }
            ?>
        </ul>


        <ul class="nav navbar-nav navbar-right">
            <?php
                if ($login){
                    echo sprintf('
                    <li>
                        <a href="#"><span class="glyphicon glyphicon-user"></span> %s</a>
                    </li>
                    ', $_SESSION["username"]);

                    echo sprintf('
                    <li>
                        <a href="%s"><span class="glyphicon glyphicon-log-out"></span> Log out</a>
                    </li>', $ABS_ROOT_PATH."/index.php?page=logout");
                }else{
                    echo sprintf('
                    <li>
                        <a href="%s"><span class="glyphicon glyphicon-log-in"></span> Log in</a>
                    </li>', $ABS_ROOT_PATH."/index.php?page=login");
                }
            ?>
        </ul>
    </div>
</nav>  