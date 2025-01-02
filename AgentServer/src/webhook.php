<?php
// Directory to store code
$repoDirectory = '/var/www/html/dod'; 

// Bitbucket webhook secret key 
$bitbucketSecret = 'BeauDesert@77'; 

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the payload from webhook
    $payload = json_decode(file_get_contents('php://input'), true);

    // //Ensure that the request is from bitbucket
    // if (!isset($_SERVER['HTTP_X_BITBUCKET_SIGNATURE'])) {
    //     die('No signature, invalid request.');
    // }

    // // Validate the signature using the Bitbucket webhook secret
    // $signature = hash_hmac('sha256', file_get_contents('php://input'), $bitbucketSecret);

    // if ($_SERVER['HTTP_X_BITBUCKET_SIGNATURE'] !== $signature) {
    //     die('Invalid signature');
    // }

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
        exec('git pull origin main', $output, $status);
        
        // Check if the pull was successful
        if ($status === 0) {
            echo "Code pulled successfully from the main branch.\n";
        } else {
            echo "Failed to pull the latest code.\n";
            echo implode("\n", $output);  // Show any error messages
        }
    } else {
        echo "No action taken for this push (not to the 'main' branch).\n";
    }
} else {
    echo "Invalid request method. Only POST is allowed.\n";
}
?>
