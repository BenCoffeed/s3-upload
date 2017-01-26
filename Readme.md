
##S3-Upload
Simple static web page for securely uploading file content to S3 buckets.

**Premise:** The idea is that each client to utilize this portal will have its own storage bucket in Amazon S3 storage. Each client will also have a portal that they log into similar to https://`Import Portal URL` /`client abbreviation` i.e. https://import.mycompany.com/myclient. Each client will also have two programattic IAM users in Amazon. There will be a write user that is used to upload documents to the bucket and a read user that is used by the application to process the uploaded data.

**Bucket Setup**  
  1. **Create the bucket** Create a new bucket in Amazon S3 Oregon region with the name formatted like import-`company abbreviation` i.e. import-myclient  
  2. **Apply CORS configuration** From the bucket's properties, expand permissions, click "Edit CORS configuration" and copy the contents Import-CORS-Policy into the editor and click save.  
  3. **Apply Bucket Policy** Still in the permissions area, click "Add/Edit Bucket Policy" and use the Import-Bucket-Policy as a template, replacing all instances of `bucket-name` with the proper name of the bucket.  

**User Setup**  
  1. **Create Read-Only User**  
     + From the Amazon IAM portal, select Users, and click the Add User at the top. Use the format import-`company abbreviation`-read i.e. import-myclient-read for the name of the user and only check the box beside "Programmatic User" and click Next: Permissions.  
     + **Apply Read-Only Permissions**  
     + Click on the "Attach existing policies directly tab"  
     + Click the "Create Policy" button  
     + Click the "Select" button next to *Create Your own Policy*  
     + Use the same name as the user for the policy name i.e. import-myclient-read  
     + Copy the contents of the Import-Read-Only-Policy into the editor and replace all instances of `bucket-name` with the name of the bucket. i.e. import-myclient  
     + Click "Next:Review" and "Create User"  
     + **Record Access Key**  
     + On the next screen, record the AWS Key ID  
     + Click the Show link next to AWS Secret Access Key and record that value as well. (Additionally, you can download a credentials.csv file containing the information)
  2. **Create Write-Only User**  
     + From the Amazon IAM portal, select Users, and click the Add User at the top. Use the format import-`company abbreviation`-write i.e. import-myclient-write for the name of the user and only check the box beside "Programmatic User" and click Next: Permissions.  
     + **Apply Write-Only Permissions**  
     + Click on the "Attach existing policies directly tab"  
     + Click the "Create Policy" button  
     + Click the "Select" button next to *Create Your own Policy*  
     + Use the same name as the user for the policy name i.e. import-myclient-write  
     + Copy the contents of the Import-Write-Only-Policy into the editor and replace all instances of `bucket-name` with the name of the bucket. i.e. import-myclient  
     + Click "Next:Review" and "Create User"  
     + **Record Access Key**  
     + On the next screen, record the AWS Key ID  
     + Click the Show link next to AWS Secret Access Key and record that value as well. (Additionally, you can download a credentials.csv file containing the information)

**Form Setup**  
  1. **Generate POST Policy**  
     + Copy the Import-Post-Policy file to a new file using a name like "Import-Post-Policy-myclient"  
     + In your newly created file, replace all instances of `bucket-name` with the name of the bucket you created earlier and save.  
  2. **Encode Policy and generate signature**  
     + From the directory type the following command replacing `pathToPolicy` with the path to the newly created policy and `SecretKey` with the Secret access key of the write-only user you created.
       $ruby genSig.rb `pathToPolicy` `SecretKey`  
       **NOTE:** This will return the name of the policy, the content of the policy, the base_64 encoded policy string, and the encoded signature. Verify that the printed Secret access Key and policy content line up with what you've created.  
     + Create a new Login entry in 1Password DevOps vault and copy the Access Key ID for the write-only user you created earlier as well as the Base64 encoded policy and signature returned from the script into the new entry.  
  **NOTE:** I typically don't use the username or password field, but rather, create three new fields with appropriate labels and set the type to password for each.  
  3. **Modify HTML form**  
     + Copy import.html to a new html file using the name format import-`company abbreviation`.html  
     + Replace all instances of `bucket-name` with the name of the bucket. i.e. import-myclient  
     + Replace `Base64-Policy` with the base64 encoded policy string you generated in the previous step  


**Deliverables**  
  When you've successfully built the form and uploaded the form to the appropriate bucket and configured the site, send the following information to the client via 2 encrypted emails replacing any highlighted items with the appropriate information.  
**Email 1**  
+ Subject: "Your SecureUpload Portal is now available"  
+ Body:  
  To access your secure portal, navigate your favorite web browser to https://`Import Portal URL` /`company abbreviation`  
  Your Access Key ID is: `Write-only Access key ID generated earlier`  
  You will be receiving a separate email with your Secure upload Signature.  

**Email 2**  
+ Subject: "Your SecureUpload Signature has been generated"  
+ Body:  
  You should have received a separate email containing a link to your portal and an Access Key ID. If you did not receive this information, please send an email to devops@myconmany.com.  
  Your Secure Upload Signature is: `Signature generated earlier`  
