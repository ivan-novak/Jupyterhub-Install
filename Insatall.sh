
# Install Anaconda

wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
sh Anaconda3-2019.10-Linux-x86_64.sh -u -b -f -p /usr/local/anaconda
export PATH=/usr/local/anaconda/bin:$PATH
conda config --add channels conda-forge
conda config --append channels r
conda init bash; 
bash -i
conda deactivate

# Install Python2 library

conda create -y -n py27 python=2.7 anaconda 
conda activate py27
conda install -y ipyparallel parallel shogun tensorflow keras pyarrow pymysql usaddress jellyfish \
findspark pyspark pytorch python-ldap pymssql tensorflow-gpu gspread google-auth-oauthlib google-api-python-client oauth2client
ipython kernel install
conda deactivate
echo '/warehouse/Data-Science/Outbox/Tools/Python2
/warehouse/Data-Engineering/Outbox/Tools/Python2
/warehouse/Development/Outbox/Tools/Python2' > /usr/local/anaconda/envs/py27/lib/python2.7/site-packages/veradata.pth

# Configuration Node's python to Py27 Envarenment

echo "export PATH=/usr/local/anaconda/envs/py27/bin:\$PATH
export SPARK_HOME=/usr/hdp/current/spark2-client
export SPARK_LOCAL_HOSTNAME=$HOSTNAME
export IPYTHONDIR=/ipyparallel
export PYSPARK_SUBMIT_ARGS='--packages graphframes:graphframes:0.3.0-spark2.0-s_2.11 pyspark-shell'
" > /etc/profile.d/anaconda-env.sh
chmod +x /etc/profile.d/anaconda-env.sh

# Install Jupyter and another kernals

conda create -y -n py36 python=3.6 anaconda 
conda activate py36
conda install -y jupyterhub
conda install -y r-irkernel bash_kernel spylon-kernel
python -m spylon_kernel install
jupyter labextension install jupyterlab-drawio
jupyter labextension install @jupyterlab/google-drive
conda deactivate

# Install Jupyter as Service

conda activate py36
echo "[Unit] 
Description=jupyterhub
[Service]
User=root
Environment='PATH=$PATH'
Environment='SPARK_HOME=/usr/hdp/current/spark2-client'
Environment='SPARK_LOCAL_HOSTNAME=$HOSTNAME'
Environment='IPYTHONDIR=/ipyparallel'
Environment='PYSPARK_SUBMIT_ARGS='--packages graphframes:graphframes:0.3.0-spark2.0-s_2.11 pyspark-shell'
ExecStart=/usr/local/anaconda/envs/py36/bin/jupyterhub \
--Spawner.notebook_dir='/warehouse' \
--Spawner.default_url='/lab' \
--Authenticator.delete_invalid_users=true \
--PAMAuthenticator.service='system-auth' \
--Spawner.env_keep=[\'PATH\',\'PYSPARK_SUBMIT_ARGS\',\'PYSPARK_PYTHON\',\'JUPYTER_PATH\',\'SPARK_HOME\',\'PYTHONSTARTUP\']
[Install]
WantedBy=multi-user.target" > /lib/systemd/system/jupyterhub.service
systemctl enable --now jupyterhub
conda deactivate

# Install Python3 library

conda activate py36
conda install -y ipyparallel parallel shogun tensorflow keras pyarrow pymysql usaddress jellyfish \
findspark pyspark pytorch python-ldap pymssql tensorflow-gpu gspread google-auth-oauthlib google-api-python-client oauth2client
ipython kernel install
conda deactivate
echo '/warehouse/Data-Science/Outbox/Tools/Python3
/warehouse/Data-Engineering/Outbox/Tools/Python3
/warehouse/Development/Outbox/Tools/Python3' > /usr/local/anaconda/envs/py36/lib/python3.6/site-packages/veradata.pth
