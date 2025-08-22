# AWS Managed Service For Flink

This is an Flink environment, but referencing what AWS provides on that offering.
The goal for this is to have a way of locally running pipelines for that stack.

### Usage
```sh
./run
./execute-job ./hello_world.py
```

#### Shutdown
1 - To stop the container run
```sh
./stop
```

2 - To remove the conatiner
```sh
./remove
```

3 - To remove the container and the image built previously
```sh
./remove -i
```