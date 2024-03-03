# step-1: run below command on windows powershell as administrator

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart


# step-2: go to microsoft windows store and search for Ubuntu & install. Enter username: ubuntu and password of your choice.

# step-3: go to programs and search for Ubuntu in all programs & run it

# step-4: you can access postgres through running command: 
sudo -u postgres psql is used to access psql server

# step-5: you can install latest postgres with command: 

# Create the file repository configuration:
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update the package lists:
sudo apt-get update

# Install the latest version of PostgreSQL.
sudo apt-get -y install postgresql-16

# Start / Stop POSTGRESQL Server:
sudo systemctl start postgresql
sudo systemctl stop postgresql
sudo systemctl restart postgresql
sudo systemctl status postgresql

# Login to POSTGRESQL:
sudo -u postgres psql