# Drop-in replacement of "hb tools install" to be removed
# as soon as the command line works within GitHub Codespaces and GitHub Actions

export DEBIAN_FRONTEND=noninteractive

sudo apt-get install -y xvfb

version=29.3.6
drawio_package=drawio-amd64-${version}.deb
curl -L -o $drawio_package https://github.com/jgraph/drawio-desktop/releases/download/v${version}/$drawio_package
sudo apt install -y ./$drawio_package
rm $drawio_package

sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y plantuml
sudo apt-get install -y graphviz
sudo apt-get install -y inkscape
sudo apt-get install -y imagemagick
