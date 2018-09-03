#!/bin/bash -ex
while true ; do 
  sleep 20
  hostname=$(hostname -s).rmq-cluster
  echo "Waiting for RabbitMQ be ready...."
  if [ $(rabbitmqctl -n ${hostname} status) ]; then
    echo "RabbitMQ is ready, setting ha policy: {{RABBITMQ_HA_POLICY}}"
    sleep 20
    rabbitmqctl -n ${hostname} set_policy ha-all '.*' "{{RABBITMQ_HA_POLICY}}" --apply-to queues
    rabbitmqctl -n ${hostname} set_policy expiry '.*' '{"expires":1800000}' --apply-to queues
    echo "ha-all policy set successfully"
    break
  fi
  echo "RabbitMQ still not ready..."
  sleep 5
done
