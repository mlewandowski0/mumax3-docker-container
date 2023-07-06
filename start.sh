#!/bin/bash

echo "pod started"
echo "$(uname -a)"

wget https://mumax.ugent.be/mumax3-binaries/mumax3.10_linux_cuda11.0.tar.gz
tar -xvf mumax3.10_linux_cuda11.0.tar.gz
rm mumax3.10_linux_cuda11.0.tar.gz
rm -rf mumax3.10 && mv mumax3.10_linux_cuda11.0 mumax3.10
mv mumax3.10/* .


if [[ $PUBLIC_KEY ]]
then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    cd ~/.ssh
    echo $PUBLIC_KEY >> authorized_keys
    chmod 700 -R ~/.ssh
    cd /
    service ssh start
fi

if [[ $JUPYTER_PASSWORD ]]
then
    cd /
    jupyter lab --allow-root --no-browser --port=8888 --ip=* --ServerApp.terminado_settings='{"shell_command":["/bin/bash"]}' --ServerApp.token=$JUPYTER_PASSWORD --ServerApp.allow_origin=* --ServerApp.preferred_dir=/workspace
else
    sleep infinity
fi