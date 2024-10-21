# Package Lambda function
Write-Host "Packaging Lambda function..."
Compress-Archive -Path index.js -DestinationPath function.zip

# Deploy to AWS Lambda
Write-Host "Deploying to AWS Lambda..."
$functionName = $env:AWS_LAMBDA_FUNCTION_PROD
$region = $env:AWS_REGION

& $awsCliPath lambda update-function-code `
    --function-name $functionName `
    --zip-file fileb://function.zip `
    --region $region `
    --access-key $env:AWS_ACCESS_KEY_ID `
    --secret-key $env:AWS_SECRET_ACCESS_KEY
