#!/bin/sh

set -ue

(
ansible all -m setup --tree /var/ansible-cmdb/facts/
ansible-cmdb -i /etc/ansible/hosts /var/ansible-cmdb/facts/ > /var/ansible-cmdb/index.html
ansible-cmdb -t txt_table -i /etc/ansible/hosts /var/ansible-cmdb/facts/ > /var/ansible-cmdb/facts.txt
ansible-cmdb -t json -i /etc/ansible/hosts /var/ansible-cmdb/facts/ > /var/ansible-cmdb/facts.json
) >> /dev/null
