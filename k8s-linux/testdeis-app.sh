# Example Go App from Deis Github https://github.com/deis/example-go

# Clone git repository with example Go app
git clone https://github.com/deis/example-go.git

cd example-go

 # Create Deis app with my-first-deis-app name
 deis create my-first-deis-app

 # Push app to Deis master
 git push deis master