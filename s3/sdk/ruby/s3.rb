require 'aws-sdk-s3'
require 'pry'
require 'securerandom'

# Define the AWS region
region = 'us-west-2'

# Retrieve the bucket name from environment variables
bucket_name = ENV['BUCKET_NAME']

# Initialize the S3 client
client = Aws::S3::Client.new(region: region)

# Create the S3 bucket
resp = client.create_bucket({
    bucket: bucket_name,
    create_bucket_configuration: {
        location_constraint: region
    }
})
#binding.pry
# Generate a random number of files to upload (between 1 and 6)
number_of_files = 1 + rand(6)
puts "number_of_files: #{number_of_files}"

# Iterate through the number of files
number_of_files.times.each do |i|
    puts "i: #{i}"
    filename = "files_#{i}.txt"
    output_path = "/tmp/#{filename}"

    # Write a UUID to each file
    File.open(output_path, "w") do |f|
        f.write SecureRandom.uuid
    end

    # Upload each file to the S3 bucket
    File.open(output_path, 'rb') do |f|
        client.put_object(
            bucket: bucket_name,
            key: filename, 
            body: f
        )
    end
end
