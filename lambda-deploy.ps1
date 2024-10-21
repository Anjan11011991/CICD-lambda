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

# Check if function name and region are not empty
if (-not $functionName -or -not $region) {
    Write-Host "Error: AWS_LAMBDA_FUNCTION_PROD or AWS_REGION is not set."
    exit 1
}

# Package Lambda function
Write-Host "Packaging Lambda function..."
Compress-Archive -Path index.js -DestinationPath function.zip

# Deploy to AWS Lambda
Write-Host "Deploying to AWS Lambda..."
$functionName = $env:secrets.AWS_LAMBDA_FUNCTION_PROD
$region = $env:secrets.AWS_REGION 

& $awsCliPath lambda update-function-code `
    --function-name $functionName `
    --zip-file fileb://function.zip `
    --region $region `
    --access-key $env:secrets.AWS_ACCESS_KEY_ID `
    --secret-key $env:secrets.AWS_SECRET_ACCESS_KEY
