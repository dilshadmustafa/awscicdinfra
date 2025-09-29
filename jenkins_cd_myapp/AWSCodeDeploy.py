#!/usr/bin/env python3
import boto3
import time
import sys
import argparse
import os
import json

awscodedeploy_client=boto3.client(service_name="codedeploy",region_name=os.getenv("REGION"))

def is_deployment_inprogress(deployment_group, codedeploy_app_name, s3_bucket):
    response = awscodedeploy_client.get_deployment_group(
        applicationName = codedeploy_app_name,
        deploymentGroupName = deployment_group
    )
    dg = response.get("deploymentGroupInfo")
    if dg.get("lastAttemptedDeployment"):
        if dg.get("lastAttemptedDeployment").get("status") == "InProgress":
            return True
    return False

def create_deployment(job_name, deployment_group, build_number, codedeploy_app_name, s3_bucket):
    s3_key = "Builds/{0}/{0}-{1}.tar".format(job_name, build_number)
    desc = "Jenkins deployment build number: {0}".format(build_number)
    response = awscodedeploy_client.create_deployment(
        applicationName = codedeploy_app_name,
        deploymentGroupName = deployment_group,
        revision={
            'revisionType': 'S3',
            's3Location': {
                'bucket': s3_bucket,
                'key': s3_key,
                'bundleType': 'tar'
            }
        },
        description = desc
    )
    return response.get('deploymentId')

def deployment_progress(deploymentID):
    now = time.time()
    response = awscodedeploy_client.get_deployment(
        deploymentId = deploymentID
    )
    response = response.get("deploymentInfo")
    status = response.get("status")
    while True:
        response = awscodedeploy_client.get_deployment(
            deploymentId = deploymentID
        )
        response = response.get("deploymentInfo")
        status = response.get("status")
        print("Progress: ", response.get("deploymentOverview"))
        later = time.time()
        diff = int(later - now)
        print("Time Consumed(in seconds): ", diff)
        sys.stdout.flush()
        if not (status == "Created" or status == "Queued" or status == "InProgress" or status == "Ready"):
            print("Status: {0} ".format(status))
            break
        if diff>1000:
            break
        time.sleep(10)
    if status == "Succeeded":
        print("Deployment is completed ")
    else:
        print(status)
        print("Deployment failed ")
        sys.exit(1)

def main(args):
    deployment_group = args.deployment_group
    codedeploy_app_name = args.codedeploy_app_name
    s3_bucket = args.s3_bucket
    if is_deployment_inprogress(args.deployment_group, args.codedeploy_app_name, args.s3_bucket):
        print("Deployment is already in progress")
        sys.exit(1)
    else:
        dp_id = create_deployment(args.job_name, deployment_group, args.build_number, args.codedeploy_app_name, args.s3_bucket)
        print("AWS CodeDeploy Deployment id is: "+ dp_id)
        deployment_progress(dp_id)
##################################################################################################################
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='CodeDeploy Script')
    parser.add_argument('-j', '--job_name', help='name of the build job', required=True)
    parser.add_argument('-d', '--deployment_group', help='deployment group', required=True)
    parser.add_argument('-b', '--build_number', help='build number', required=True)
    parser.add_argument('-c', '--codedeploy_app_name', help='codedeploy_app_name', required=True)
    parser.add_argument('-s', '--s3_bucket', help='s3_bucket', required=True)
    args = parser.parse_args()
    main(args)