this demo-8 uses bucket to store a version/state of terraform.
because when working with multiple developers/QA teams,
the apply might be taken by the first who made the changes, 
and thus, versioning is needed for backup.
saving of states is via S3 bucket, and also locking while applying, 
to prevent conflicts of teams trying to apply while another team is.

a state cannot accept variable because its a fixed state-with all the data 
fixed for it to know what to deploy.


so terraform *doesn't* save the state locally<<!!
because then it wouldn't be updated to the whole branch/version of everyone
else's.
