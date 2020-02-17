bundle exec whenever --update-crontab
printenv | sed 's/^\(.*\)$/export \1/g' > /root/project_env.sh
sed -i '/imklog/s/^/#/' /etc/rsyslog.conf
touch /var/log/rsyslog
service rsyslog start
service start crontab
rails s -b 0.0.0.0
