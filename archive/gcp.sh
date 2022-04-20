#Create Postgres DB instance on GCP

gcloud compute instances create crypto-trace-postgres-primary \
--project=cryptic-acrobat-330120 \
--zone=us-west1-b \
--machine-type=n2-standard-4 \
--network-interface=network-tier=PREMIUM,subnet=default \
--maintenance-policy=MIGRATE \
--service-account=crypto-trace-dev@cryptic-acrobat-330120.iam.gserviceaccount.com \
--scopes=https://www.googleapis.com/auth/cloud-platform \
--create-disk=boot=yes,device-name=disk-postgres-ether-prod,image=projects/debian-cloud/global/images/debian-10-buster-v20211105,mode=rw,size=2048,type=projects/cryptic-acrobat-330120/zones/us-west1-b/diskTypes/pd-standard \
--no-shielded-secure-boot \
--shielded-vtpm \
--shielded-integrity-monitoring \
--reservation-affinity=any

Create separeate instance and add additional disk.

https://cloud.google.com/compute/docs/disks/add-persistent-disk

