#!/bin/bash

set -euo pipefail

ANSIBLE_VERSION="2.8.3"
TERRAFORM_VERSION="0.12.7"
PACKER_VERSION="1.4.2"

function check_version_virtualenv() {
  printf "Checking for virtualenv ..."
  if [ ! -e env/bin/activate ]; then
    printf ' \x1b[33mno virtualenv\x1b[0m\n'
    install_virtualenv
  else
    printf ' \x1b[32mok!\x1b[0m\n'
  fi

  SKIP_SIGNIN=1 source env/bin/activate
}

function check_version_ansible() {
  printf "Checking ansible version ..."

  if [ -z "$(which ansible)" ]; then
    install_ansible
  elif [ "$(ansible --version | head -n1 | awk '{print $2}')" != "$ANSIBLE_VERSION" ]; then
    install_ansible
  else
    printf " \x1b[32mok!\x1b[0m\n"
  fi
}

function check_version_packer() {
  printf "Checking packer version ..."

  if [ -z "$(which packer)" ]; then
    install_packer
  elif [ "$(packer -v)" != "${PACKER_VERSION}" ]; then
    install_packer
  else
    printf " \x1b[32mok!\x1b[0m\n"
  fi
}

function check_version_terraform() {
  printf "Checking terraform version ..."

  if [ -z "$(which terraform)" ]; then
    install_terraform
  elif [ "$(terraform -v | head -n1 | awk '{print $2}')" != "v${TERRAFORM_VERSION}" ]; then
    install_terraform
  else
    printf " \x1b[32mok!\x1b[0m\n"
  fi
}

function get_platform() {
  if [ "$OSTYPE" == "linux-gnu" ]; then
    echo linux
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo darwin
  elif [ "$OSTYPE" == "cygwin" ]; then
    echo windows
  elif [ "$OSTYPE" == "msys" ]; then
    echo windows
  elif [ "$OSTYPE" == "win32" ]; then
    echo windows
  else
    echo "Cannot detect OS" >&2
    exit 1
  fi
}

function get_arch() {
  case $(uname -m) in
    x86_64)
    echo amd64
  ;;
    i*86)
    echo 386
  ;;
  esac
}

function install_ansible() {
  pip install paramiko
  pip install awscli
  CFLAGS=-Qunused-arguments CPPFLAGS=-Qunused-arguments pip install "ansible==${ANSIBLE_VERSION}"
}

function install_packer() {
  plat=$(get_platform)
  arch=$(get_arch)
  echo "downloading packer @ ${PACKER_VERSION}:"
  curl -#o env/bin/.packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_${plat}_${arch}.zip
  unzip -qo env/bin/.packer.zip -d env/bin
}

function install_terraform() {
  plat=$(get_platform)
  arch=$(get_arch)

  echo "downloading terraform @ ${TERRAFORM_VERSION}:"
  curl -#o env/bin/.terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${plat}_${arch}.zip
  unzip -qo env/bin/.terraform.zip -d env/bin
}

function install_virtualenv() {
  pip3 install --user virtualenv
  python3 -m virtualenv env
}

check_version_virtualenv # this one has to come first!

check_version_ansible
check_version_packer
check_version_terraform
npm i

echo 'Activating virtualenv in order to check your credentials. You will be prompted for your password and secret key for 1password.'
deactivate
SKIP_SIGNIN= . env/bin/activate

