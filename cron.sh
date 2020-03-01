#!/bin/bash
while sleep 60; do
  bundle exec bin/rails runner -e development 'Message.send_due_messages'
done
