#!/bin/bash
docker run -it --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /hpc/home/connect.zzheng989/researchlib/Fuzz_RTL:/root/Fuzz_RTL \
    difuzz