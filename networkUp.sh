echo
echo "**************************************************************"
echo "########   Start Network Up    #############"
echo "**************************************************************"
echo
echo
echo "**************************************************************"
echo "Removing All docker containers"
echo "**************************************************************"
echo
docker rm -vf $(docker ps -aq)
sleep 1

cd ${PWD}/channel-artifacts/
sudo rm -rf mychannel.block

cd ../artifacts/channel/

echo
echo "**************************************************************"
echo "Removing crypto-config genesis mychannel and anchors"
echo "**************************************************************"
echo

sudo rm -rf crypto-config/
sudo rm -rf genesis.block
sudo rm -rf mychannel.tx
sudo rm -rf Org1MSPanchors.tx
sudo rm -rf Org2MSPanchors.tx

cd create-certificate-with-ca
sleep 2
echo
echo "**************************************************************"
echo "Removing fabric ca"
echo "**************************************************************"
echo

sudo rm -rf fabric-ca/
sleep 2
docker-compose up -d

sleep 2
echo
echo "**************************************************************"
echo "creating fabric ca"
echo "**************************************************************"
echo
./create-certificate-with-ca.sh

cd ../
sleep 1
echo
echo "**************************************************************"
echo "creating channel aritfacts"
echo "**************************************************************"
echo
./create-artifacts.sh
cd ../
sleep 2
docker-compose up -d
cd ../
sleep 2
echo
echo "**************************************************************"
echo "create channel"
echo "**************************************************************"
echo
./createChannel.sh
sleep 2
echo
echo "**************************************************************"
echo "deploy chaincode for DQN"
echo "**************************************************************"
echo
./deployDQNChaincode.sh
sleep 2

echo
echo "**************************************************************"
echo "deploy chaincode for DDQN"
echo "**************************************************************"
echo
./deployDDQNChaincode.sh
sleep 2

echo
echo "**************************************************************"
echo "Remove wallet and connection-profiles and creating new"
echo "**************************************************************"
echo
cd api/
sudo rm -rf org1-wallet/
sudo rm -rf org2-wallet/
cd config/
sudo rm -rf connection-org1.json
sudo rm -rf connection-org2.json
./generate-ccp.sh
cd ..
node initServer.js
sleep 2

# echo
# echo "**************************************************************"
# echo "deploy chaincode for DDQN"
# echo "**************************************************************"
# echo
# ./deployDDQNChaincode.sh
# sleep 2

echo
echo "**************************************************************"
echo "########   Network Up   #############"
echo "**************************************************************"
echo
