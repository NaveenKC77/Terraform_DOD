<?php
// Directory to store code
$repoDirectory = '/var/www/html/webhooktest'; 

// Bitbucket webhook secret key 
$bitbucketSecret = ''; 

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the payload from webhook
    $payload = json_decode(file_get_contents('php://input'), true);

    // Log the event for debugging 
    file_put_contents('webhook.log', print_r($payload, true), FILE_APPEND);
    
    // Check the repository and branch details from the payload
    $repositoryName = $payload['repository']['name'] ?? 'Unknown';
    $ref = $payload['push']['changes'][0]['new']['name'] ?? '';

    if ($ref === 'main') {  // Check if the push is to the 'main' branch
        echo "Repository: $repositoryName\n";
        echo "Branch: main\n";
        
        // Change to the repository directory
        chdir($repoDirectory);
      
        // Pull the latest code from the repository
        $output = shell_exec('sudo git pull origin main');
        
        // Check if the pull was successful
        if ($output) {
            echo "Code pulled successfully from the main branch.\n";
        } else {
            echo "Failed to pull the latest code.\n";
            echo implode("\n", $output);  
        }
    } else {
        echo "Not pushed to main branch ";
    }
} else {
    echo "Invalid request method";
}
?>


<!-- allow access to www-data -->
 <!-- www-data ALL=(ALL) NOPASSWD:ALL -->

 <!-- Allow access to var/www/html/repo -->
 <!-- sudo chown -R www-data:www-data /var/www/html
 sudo chmod -R 755 /var/www/html -->