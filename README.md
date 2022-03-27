Prerequisites:

* GCP account wih project
* terraform installed
* gcloud installed

On OS X

```
brew install terraform google-cloud-sdk
```

Usage:

Set GCP project name and region in `locals.tf`

```
terraform init
terraform apply
gcloud container clusters get-credentials gke-test-1 --region <REGION NAME>
```
