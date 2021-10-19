#!/bin/bash
echo "Creating Org"
sfdx force:org:create edition=Developer -a developerOrg -s
echo "Deploying Files"
sfdx force:source:deploy -p force-app
echo "Deployment finished"

sfdx force:org:display
