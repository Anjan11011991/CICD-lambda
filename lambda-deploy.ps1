# Check if function.zip already exists and delete it if so
if (Test-Path -Path "function.zip") {
    Remove-Item -Path "function.zip" -Force
}

# Package the Lambda function
Write-Host "Packaging Lambda function..."
Compress-Archive -Path "index.js" -DestinationPath "function.zip"

# Set AWS Lambda function name and region from environment variables
$functionName = $env:AWS_LAMBDA_FUNCTION_PROD
$region = $env:AWS_REGION

# Update AWS Lambda function code
Write-Host "Deploying to AWS Lambda..."
& aws lambda update-function-code `
    --function-name $functionName `
    --zip-file fileb://function.zip `
    --region $region `
    --access-key $env:AWS_ACCESS_KEY_ID `
    --secret-key $env:AWS_SECRET_ACCESS_KEY
