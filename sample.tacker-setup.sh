#!/usr/bin/env bash

# Test servicevm via the command line

echo "*********************************************************************"
echo "Begin Tacker Setup : $0"
echo "*********************************************************************"

# This script exits on an error so that errors don't compound and you see
# only the first error that occurred.
set -o errexit

# Print the commands being run so that we can see the command that triggers
# an error.  It is also useful for following allowing as the install occurs.
set -o xtrace


# Settings
# ========

################################
# Customize to your installation
################################
TOP_DIR=<DEVSTACK_TOP_DIR>

# Import common functions
source $TOP_DIR/functions

# Import configuration
source $TOP_DIR/openrc

# Import exercise configuration
source $TOP_DIR/exerciserc


# create necessary networks
# prepare network
MGMT_PHYS_NET=mgmtphysnet0
BR_MGMT=br-mgmt0
NET_MGMT=net_mgmt
SUBNET_MGMT=subnet_mgmt
FIXED_RANGE_MGMT=10.253.255.0/24
NETWORK_GATEWAY_MGMT=10.253.255.1
NETWORK_GATEWAY_MGMT_IP=10.253.255.1/24

NET0=net0
SUBNET0=subnet0
FIXED_RANGE0=10.253.0.0/24
NETWORK_GATEWAY0=10.253.0.1

NET1=net1
SUBNET1=subnet1
FIXED_RANGE1=10.253.1.0/24
NETWORK_GATEWAY1=10.253.1.1

NET2=net2
SUBNET2=subnet2
FIXED_RANGE2=10.253.2.0/24
NETWORK_GATEWAY2=10.253.2.1


for net in ${NET_MGMT} ${NET0} ${NET1} ${NET2}
do
    for i in $(neutron net-list | awk "/${net}/{print \$2}")
    do
	neutron net-delete $i
    done
done


NET_MGMT_ID=$(neutron net-create --provider:network_type flat --provider:physical_network ${MGMT_PHYS_NET} --shared ${NET_MGMT} | awk '/ id /{print $4}')
SUBNET_MGMT_ID=$(neutron subnet-create --name ${SUBNET_MGMT} --ip-version 4 --gateway ${NETWORK_GATEWAY_MGMT} ${NET_MGMT_ID} ${FIXED_RANGE_MGMT} | awk '/ id /{print $4}')
NET0_ID=$(neutron net-create --shared ${NET0} | awk '/ id /{print $4}')
SUBNET0_ID=$(neutron subnet-create --name ${SUBNET0} --ip-version 4 --gateway ${NETWORK_GATEWAY0} ${NET0_ID} ${FIXED_RANGE0} | awk '/ id /{print $4}')
NET1_ID=$(neutron net-create --shared ${NET1} | awk '/ id /{print $4}')
SUBNET1_ID=$(neutron subnet-create --name ${SUBNET1} --ip-version 4 --gateway ${NETWORK_GATEWAY1} ${NET1_ID} ${FIXED_RANGE1} | awk '/ id /{print $4}')
NET2_ID=$(neutron net-create --shared ${NET2} | awk '/ id /{print $4}')
SUBNET2_ID=$(neutron subnet-create --name ${SUBNET2} --ip-version 4 --gateway ${NETWORK_GATEWAY2} ${NET2_ID} ${FIXED_RANGE2} | awk '/ id /{print $4}')

echo ${NET_MGMT_ID}
echo ${SUBNET_MGMT_ID}
echo ${NET0_ID}
echo ${SUBNET0_ID}
echo ${NET1_ID}
echo ${SUBNET1_ID}
echo ${NET2_ID}
echo ${SUBNET2_ID}

sudo ifconfig ${BR_MGMT} inet 0.0.0.0
sudo ifconfig ${BR_MGMT} inet ${NETWORK_GATEWAY_MGMT_IP}

set +o xtrace
echo "*********************************************************************"
echo "SUCCESS: End Tacker Setup : $0"
echo "*********************************************************************"
