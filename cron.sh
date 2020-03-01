#!/bin/bash
while sleep 60; do
  date
  bundle exec rails runner 'Message.send_due_messages'
done
