# set fake profile

# waiting for moto to start, yes that's a terrible way to do that I know...
sleep 5

export AWS_ACCESS_KEY_ID=s;
export AWS_SECRET_ACCESS_KEY=s;
export AWS_DEFAULT_REGION=us-east-1

# create the bucket, put the CSV into it.
aws s3api create-bucket --bucket test --endpoint-url http://moto:5000

aws s3api put-object --bucket test --key raw_customers.csv --body ../csvs/raw_customers.csv --endpoint-url http://moto:5000
aws s3api put-object --bucket test --key raw_orders.csv --body ../csvs/raw_orders.csv --endpoint-url http://moto:5000
aws s3api put-object --bucket test --key raw_payments.csv --body ../csvs/raw_payments.csv --endpoint-url http://moto:5000

# this is how you would retrieve it again...
# aws s3api get-object --bucket test --key raw_customers.csv test.csv --endpoint-url http://moto:5000

# Coming from the outside (not the docker-compose network), this should work
# aws s3api list-buckets --endpoint-url http://localhost:5005

# keep awake and let users do more if needed...

echo "leave this terminal open and open another one to continue!"
sh