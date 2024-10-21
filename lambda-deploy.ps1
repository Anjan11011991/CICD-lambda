# Check if function.zip already exists and delete it if so
if (Test-Path -Path "function.zip") {
    Remove-Item -Path "function.zip" -Force
}

# Package Lambda function
Write-Host "Packaging Lambda function..."
Compress-Archive -Path "index.js" -DestinationPath "function.zip"

# Set AWS Lambda function name and region from environment variables
$functionName = $env:AWS_LAMBDA_FUNCTION_PROD
$region = $env:AWS_REGION
$awsAccessKeyId = $env:AWS_ACCESS_KEY_ID
$awsSecretAccessKey = $env:AWS_SECRET_ACCESS_KEY

# Check if required variables are set
if (-not $functionName -or -not $region -or -not $awsAccessKeyId -or -not $awsSecretAccessKey) {
    Write-Host "Error: One or more required environment variables are not set."
    exit 1
}

# Deploy to AWS Lambda
Write-Host "Deploying to AWS Lambda..."
& aws lambda update-function-code `
    --function-name $functionName `
    --zip-file fileb://function.zip `
    --region $region `
    --access-key $awsAccessKeyId `
    --secret-key $awsSecretAccessKey
