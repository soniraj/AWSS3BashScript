S3KEY="XXXXXXX" #Enter your S3 Key
S3SECRET="" #Enter your S3 Secret key
path='' #Enter the path wher all file is e.g. /home/ubuntu/logs

function putS3()
{
  path='' #Enter the path wher all file is e.g. /home/ubuntu/logs
  file=$sendFile
  aws_path='' #In s3 where you want to store all the files eg  'S3Logs'. Here all your files from server will be transfered to S3 Bucket in S3Logs folder
  bucket='' #Enter your S3 bucket name
  date=`TZ=utc  date -R`
  acl="x-amz-acl:public-read"
  content_type='multipart/form-data'
  resource="/${bucket}/${file}"
    string="PUT\n\n$content_type\n$date\n$acl\n/$bucket/$aws_path/$file"
    signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
    curl -X PUT -T "$path/$file" \
    -H "Host: $bucket.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$bucket.s3.amazonaws.com/$aws_path/$file"
}

for file in "$path"/*; do
  sendFile="${file##*/}"
  putS3 $sendFile
done


