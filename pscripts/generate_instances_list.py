import boto3

ec2 = boto3.resource('ec2')

with open('instances_ip.txt', "w") as f:
    for instance in ec2.instances.all():
        if instance.state['Name'] == 'running':
            f.write(f'ssh -oStrictHostKeyChecking=no -i "ec2-keypair.pem" ec2-user@{instance.public_ip_address}\n')