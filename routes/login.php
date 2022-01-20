<link rel="stylesheet" type="text/css" href="<?= $ABS_ROOT_PATH ?>/styles/login.css">

<h3 class="title">Login Form</h3>
<p class="description">Log in here Using Username & Password</p>



<form action="<?= $ABS_ROOT_PATH ?>/model/login_processing.php" method="post">
    <div class="form-group">
        <input type="text" name="username" class="form-control" placeholder="Enter username" required>
    </div>
    <div class="form-group">
        <input type="password" name="password" class="form-control" placeholder="Password" required>
    </div>
    <br>
    <input class="btn" type="submit" value="Login">
</form>