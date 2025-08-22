ARG FLINK_TAG=1.18.1-scala_2.12-java11
FROM flink:${FLINK_TAG}

ENV DEBIAN_FRONTEND=noninteractive

# Python 3.10 + Maven
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3.10 python3.10-venv python3-pip ca-certificates maven unzip \
    && rm -rf /var/lib/apt/lists/*

# Virtualenv + PyFlink 1.18.1
RUN python3.10 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip setuptools wheel && \
    /opt/venv/bin/pip install "apache-flink==1.18.1"

# Seus pacotes Python
COPY requirements.txt .
RUN /opt/venv/bin/pip install -r requirements.txt

# PyFlink usa o Python do venv
ENV PATH="/opt/venv/bin:${PATH}"
ENV PYFLINK_CLIENT_EXECUTABLE="/opt/venv/bin/python3"
ENV PYFLINK_EXECUTABLE="/opt/venv/bin/python3"
ENV PYTHONPATH="/opt/venv/lib/python3.10/site-packages:${PYTHONPATH}"

# Limpa conectores de outras versões, se tiver sobrado algo
RUN rm -f /opt/flink/lib/flink-connector-aws* /opt/flink/lib/flink-connector-kinesis*.jar || true

# === Conector Kinesis compatível com Flink 1.18 (DataStream/consumer) ===
# Doc oficial 1.18 indica este artefato
RUN mvn -q org.apache.maven.plugins:maven-dependency-plugin:3.6.1:copy \
      -Dartifact=org.apache.flink:flink-connector-kinesis:4.3.0-1.18 \
      -DoutputDirectory=/opt/flink/lib

RUN mvn -q org.apache.maven.plugins:maven-dependency-plugin:3.6.1:copy \
      -Dartifact=joda-time:joda-time:2.12.7 \
      -DoutputDirectory=/opt/flink/lib

      # (Opcional) Se o runtime reclamar do LogFactory, adicione o JCL (raro precisar no 4.3.0-1.18)
RUN mvn -q org.apache.maven.plugins:maven-dependency-plugin:3.6.1:copy \
      -Dartifact=commons-logging:commons-logging:1.2 \
      -DoutputDirectory=/opt/flink/lib

EXPOSE 8081
