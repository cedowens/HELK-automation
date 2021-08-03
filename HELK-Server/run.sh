#!/bin/bash

echo "*******************************************************************"
echo "  Welcome to the Terraform Script Runner to Set Up Your Cloud HELK Server!  "
echo "*******************************************************************"
echo ""
echo "Have you already installed terraform? (Y/N)?"
read installed

if [[ ("$installed" ==  "N") || ("$installed" == "n") ]];then
	ostype=$(uname)
	if [[ "$ostype" == "Linux" ]]; then
		echo "attempting to install terraform (linux install)..."
		curl -o ~/terraform.zip https://releases.hashicorp.com/terraform/0.13.1/terraform_0.13.1_linux_amd64.zip
		mkdir -p ~/opt/terraform
		sudo apt install unzip
		unzip ~/terraform.zip -d ~/opt/terraform
		echo "Next add terraform to your path (append export PATH=$PATH:~/opt/terraform/bin to the end)"
		nano ~/.bashrc
		. .bashrc
	elif [[ "$ostype" == "Darwin" ]]; then
		echo "Attempting to install terraform (macOS Homebrew install)..."
		brew tap hashicorp/tap
		brew install hashicorp/tap/terraform

	fi
fi
echo "=====>Enter the name you want to call your new Digital Ocean HELK server"
read dropletName
echo "=====>Enter the name that you want to call your Digital Ocean Firewall"
read firewallName
echo "=====>Enter the src IP that you will ssh into your HELK server from (i.e., terraform will set up a firewall only allowing ssh/admin access in from this src IP)"
read adminIP
echo "=====>Enter the publicly routable IP address of the test macOS host that will connect to the HELK server (irewall rules will restrict port 443 access to this host only)"
read macIP
echo "=====>Enter your Digital Ocean Access Token"
read DOAPIKEY
echo "=====>Enter the name of your Digital Ocean ssh key (can be found in your admin console panel or you can create one there if you haven't already)"
read keyName
echo "=====>Enter the local path to the ssh private key that you want Terraform to use to ssh into this Digital Ocean host (ex: ~/.ssh/id_rsa)"
read keyPath

sed -i -e "s/myc2-1/$dropletName/g" init.tf
sed -i -e "s/myc2rule/$firewallName/g" init.tf
sed -i -e "s/keyname/$keyName/g" init.tf
sed -i -e "s/127.0.0.1/$adminIP/g" init.tf
sed -i -e "s/10.0.0.0/$macIP/g" init.tf
sed -i -e "s/mydotoken/$DOAPIKEY/g" init.tf

terraform init
echo "====>Running terraform plan for the new redirector..."
terraform plan -var "do_token=$DOAPIKEY" -var "pvt_key=$keyPath"
echo "====>Applying the terraform plan..."
terraform apply -var "do_token=$DOAPIKEY" -var "pvt_key=$keyPath"
cp orig/init-orig.tf init.tf
