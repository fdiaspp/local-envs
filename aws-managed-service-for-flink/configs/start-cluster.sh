#!/bin/bash

# 1) Limpa PIDs antigos e reinicia como flink
export FLINK_PID_DIR=/opt/flink/pids
mkdir -p "$FLINK_PID_DIR" && chown -R flink:flink "$FLINK_PID_DIR"

# para cluster (se estiver rodando) e ignora erro
su -s /bin/bash flink -c "/opt/flink/bin/stop-cluster.sh || true"

# remove PIDs órfãos
rm -f /tmp/flink-*-standalonesession.pid /tmp/flink-*-taskexecutor.pid

# inicia cluster como flink, já com diretório de PID definido
su -s /bin/bash flink -c "export FLINK_PID_DIR=$FLINK_PID_DIR; /opt/flink/bin/start-cluster.sh"
