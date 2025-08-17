ARG FLINK_TAG=1.20.0-scala_2.12-java17
FROM flink:1.20.0-scala_2.12-java17

# Avoid apt prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install Python 3.11 + pip + venv
# (Flink images are usually based on Debian/Ubuntu)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.11 \
        python3.11-venv \
        python3-pip \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python3.11 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip setuptools wheel

# Install PyFlink corresponding to Flink 1.20
# (the PyPI package is "apache-flink")
RUN /opt/venv/bin/pip install "apache-flink==1.20.0"

# Make it easy to install extra libs later (e.g.: pandas, requests, etc.)
# RUN /opt/venv/bin/pip install pandas requests

# Environment variables for PyFlink to use the venv Python
ENV PATH="/opt/venv/bin:${PATH}"
ENV PYFLINK_CLIENT_EXECUTABLE="/opt/venv/bin/python3"
ENV PYFLINK_EXECUTABLE="/opt/venv/bin/python3"
# Ensure Python finds the venv packages in all processes
ENV PYTHONPATH="/opt/venv/lib/python3.11/site-packages:${PYTHONPATH}"

# Download Kinesis JARs directly from Maven
RUN curl -fsSL https://repo1.maven.org/maven2/org/apache/flink/flink-connector-kinesis/5.0.0-1.20/flink-connector-kinesis-5.0.0-1.20.jar \
        -o /opt/flink/lib/flink-connector-kinesis-5.0.0-1.20.jar && \
    curl -fsSL https://repo1.maven.org/maven2/org/apache/flink/flink-connector-aws-kinesis-streams/5.0.0-1.20/flink-connector-aws-kinesis-streams-5.0.0-1.20.jar \
        -o /opt/flink/lib/flink-connector-aws-kinesis-streams-5.0.0-1.20.jar

# Flink Web UI port
EXPOSE 8081
