from pyflink.datastream import StreamExecutionEnvironment

def main():
    env = StreamExecutionEnvironment.get_execution_environment()
    env.set_parallelism(1)

    ds = env.from_collection(["Hello, World! via Flink DataStream 🚀"])
    ds.print()

    env.execute("hello-world-datastream")

if __name__ == "__main__":
    main()
