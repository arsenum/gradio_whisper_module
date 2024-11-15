# docker-compose up --build
# exit
# docker-compose up -d
# webhook -hooks hooks.json -verbose &
# lt --port 9000
fuser -k 9000/tcp
webhook -hooks hooks.json  &
lt --port 9000 > lt_output.txt &
# Start localtunnel and capture its output
# Wait for localtunnel to respond with the URL
while true; do
  if grep -q "your url is:" lt_output.txt; then
    export CALL_BACK=$(grep "your url is:" lt_output.txt | awk '{print $NF}')
    echo $CALL_BACK
    break
  fi
  sleep 1
done

 
#  exit
# output=$(echo "$(bacalhau docker run --network=Full --entrypoint=./run_app.sh --env \"CALL_BACK=$CALL_BACK\"  arsen3d/gradio_whisper:latest)" | tail -n 1)
# echo $output
rm -rf /tmp/lilypad/data/repos/arsenum/gradio_whisper_module
lilypad run github.com/arsenum/gradio_whisper_module:main --target 0xd10D15cc705f7D2558352B1212A9b3685155d93D --web3-private-key=$WEB3_USER_PRIVATE_KEY -i ENV="CALL_BACK=$CALL_BACK"
# lilypad run github.com/lilypad-tech/lilypad-module-cowsay:main --target 0xd10D15cc705f7D2558352B1212A9b3685155d93D --web3-private-key=$WEB3_USER_PRIVATE_KEY -i ENV="CALL_BACK=$CALL_BACK"
exit
# last_line=$(echo "$(output)")
# echo $("$output")
trimmed_output=$(echo "$output" | sed 's/^[ \t]*//')
echo $($trimmed_output)
status=$($output --json | jq '.["State"]["Executions"][0]["Status"]')
if [ "$status" = "\"Accepted job. execution completed\"" ]; then
    echo "Test Job completed successfully"
else
    echo "Test Job failed with status: $status"
    sleep infinity
fi
echo "Loading App"
$last_line

# Usage:
#   bacalhau docker run [flags] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]

# Examples:
#   # Run a Docker job, using the image 'dpokidov/imagemagick', with a CID mounted at /input_images and an output volume mounted at /outputs in the container. All flags after the '--' are passed directly into the container for execution.
#   bacalhau docker run \
#   -i src=ipfs://QmeZRGhe4PmjctYVSVHuEiA9oSXnqmYa4kQubSHgWbjv72,dst=/input_images \
#   dpokidov/imagemagick:7.1.0-47-ubuntu \
#   -- magick mogrify -resize 100x100 -quality 100 -path /outputs '/input_images/*.jpg'
  
#   # Dry Run: check the job specification before submitting it to the bacalhau network
#   bacalhau docker run --dry-run ubuntu echo hello
  
#   # Save the job specification to a YAML file
#   bacalhau docker run --dry-run ubuntu echo hello > job.yaml
  
#   # Specify an image tag (default is 'latest' - using a specific tag other than 'latest' is recommended for reproducibility)
#   bacalhau docker run ubuntu:bionic echo hello
  
#   # Specify an image digest
#   bacalhau docker run ubuntu@sha256:35b4f89ec2ee42e7e12db3d107fe6a487137650a2af379bbd49165a1494246ea echo hello

# Flags:
#       --concurrency int                         How many nodes should run the job (default 1)
#       --cpu string                              Job CPU cores (e.g. 500m, 2, 8).
#       --disk string                             Job Disk requirement (e.g. 500Gb, 2Tb, 8Tb).
#       --do-not-track                            When true the job will not be tracked(?) TODO BETTER DEFINITION
#       --domain stringArray                      Domain(s) that the job needs to access (for HTTP networking)
#       --download                                Should we download the results once the job is complete?
#       --download-timeout-secs duration          Timeout duration for IPFS downloads. (default 5m0s)
#       --dry-run                                 Do not submit the job, but instead print out what will be submitted
#       --entrypoint strings                      Override the default ENTRYPOINT of the image
#   -e, --env strings                             The environment variables to supply to the job (e.g. --env FOO=bar --env BAR=baz)
#   -f, --follow                                  When specified will follow the output from the job as it runs
#   -g, --gettimeout int                          Timeout for getting the results of a job in --wait (default 10)
#       --gpu string                              Job GPU requirement (e.g. 1, 2, 8).
#   -h, --help                                    help for run
#       --id-only                                 Print out only the Job ID on successful submission.
#   -i, --input storage                           Mount URIs as inputs to the job. Can be specified multiple times. Format: src=URI,dst=PATH[,opt=key=value]
#                                                 Examples:
#                                                 # Mount IPFS CID to /inputs directory
#                                                 -i ipfs://QmeZRGhe4PmjctYVSVHuEiA9oSXnqmYa4kQubSHgWbjv72
                                                
#                                                 # Mount S3 object to a specific path
#                                                 -i s3://bucket/key,dst=/my/input/path
                                                
#                                                 # Mount S3 object with specific endpoint and region
#                                                 -i src=s3://bucket/key,dst=/my/input/path,opt=endpoint=https://s3.example.com,opt=region=us-east-1
                                                
#       --ipfs-api-listen-addresses strings       addresses the internal IPFS node will listen on for API connections (default [/ip4/0.0.0.0/tcp/0]) (DEPRECATED: The embedded IPFS node will be removed in a future versionin favour of using --ipfs-connect and a self-hosted IPFS node)
#       --ipfs-connect string                     The ipfs host multiaddress to connect to, otherwise an in-process IPFS node will be created if not set.
#       --ipfs-gateway-listen-addresses strings   addresses the internal IPFS node will listen on for gateway connections (default [/ip4/0.0.0.0/tcp/0]) (DEPRECATED: The embedded IPFS node will be removed in a future versionin favour of using --ipfs-connect and a self-hosted IPFS node)
#       --ipfs-profile string                     profile for internal IPFS node (default "flatfs") (DEPRECATED: The embedded IPFS node will be removed in a future versionin favour of using --ipfs-connect and a self-hosted IPFS node)
#       --ipfs-serve-path string                  path local Ipfs node will persist data to (DEPRECATED: The embedded IPFS node will be removed in a future versionin favour of using --ipfs-connect and a self-hosted IPFS node)
#       --ipfs-swarm-addrs strings                IPFS multiaddress to connect the in-process IPFS node to - cannot be used with --ipfs-connect. (default [/ip4/35.245.161.250/tcp/4001/p2p/12D3KooWAQpZzf3qiNxpwizXeArGjft98ZBoMNgVNNpoWtKAvtYH,/ip4/34.86.254.26/tcp/4001/p2p/12D3KooWLfFBjDo8dFe1Q4kSm8inKjPeHzmLBkQ1QAjTHocAUazK,/ip4/35.245.215.155/tcp/4001/p2p/12D3KooWH3rxmhLUrpzg81KAwUuXXuqeGt4qyWRniunb5ipjemFF,/ip4/34.145.201.224/tcp/4001/p2p/12D3KooWBCBZnXnNbjxqqxu2oygPdLGseEbfMbFhrkDTRjUNnZYf,/ip4/35.245.41.51/tcp/4001/p2p/12D3KooWJM8j97yoDTb7B9xV1WpBXakT4Zof3aMgFuSQQH56rCXa]) (DEPRECATED: The embedded IPFS node will be removed in a future versionin favour of using --ipfs-connect and a self-hosted IPFS node)
#       --ipfs-swarm-key string                   Optional IPFS swarm key required to connect to a private IPFS swarm (DEPRECATED: The embedded IPFS node will be removed in a future versionin favour of using --ipfs-connect and a self-hosted IPFS node)
#       --ipfs-swarm-listen-addresses strings     addresses the internal IPFS node will listen on for swarm connections (default [/ip4/0.0.0.0/tcp/0]) (DEPRECATED: The embedded IPFS node will be removed in a future versionin favour of using --ipfs-connect and a self-hosted IPFS node)
#   -l, --labels strings                          List of labels for the job. Enter multiple in the format '-l a -l 2'. All characters not matching /a-zA-Z0-9_:|-/ and all emojis will be stripped.
#       --memory string                           Job Memory requirement (e.g. 500Mb, 2Gb, 8Gb).
#       --network network-type                    Networking capability required by the job. None, HTTP, or Full (default None)
#       --node-details                            Print out details of all nodes (overridden by --id-only).
#   -o, --output strings                          name:path of the output data volumes. 'outputs:/outputs' is always added unless '/outputs' is mapped to a different name. (default [outputs:/outputs])
#       --output-dir string                       Directory to write the output to.
#       --private-internal-ipfs                   Whether the in-process IPFS node should auto-discover other nodes, including the public IPFS network - cannot be used with --ipfs-connect. Use "--private-internal-ipfs=false" to disable. To persist a local Ipfs node, set BACALHAU_SERVE_IPFS_PATH to a valid path. (default true) (DEPRECATED: The embedded IPFS node will be removed in a future versionin favour of using --ipfs-connect and a self-hosted IPFS node)
#   -p, --publisher publisher                     Where to publish the result of the job
#       --raw                                     Download raw result CIDs instead of merging multiple CIDs into a single result
#   -s, --selector string                         Selector (label query) to filter nodes on which this job can be executed, supports '=', '==', and '!='.(e.g. -s key1=value1,key2=value2). Matching objects must satisfy all of the specified label constraints.
#       --target all|any                          Whether to target the minimum number of matching nodes ("any") (default) or all matching nodes ("all") (default any)
#       --timeout int                             Job execution timeout in seconds (e.g. 300 for 5 minutes)
#       --wait                                    Wait for the job to finish. Use --wait=false to return as soon as the job is submitted. (default true)
#       --wait-timeout-secs int                   When using --wait, how many seconds to wait for the job to complete before giving up. (default 600)
#   -w, --workdir string                          Working directory inside the container. Overrides the working directory shipped with the image (e.g. via WORKDIR in Dockerfile).

# Global Flags:
#       --api-host string         The host for the client and server to communicate on (via REST).
#                                 Ignored if BACALHAU_API_HOST environment variable is set. (default "bootstrap.production.bacalhau.org")
#       --api-port int            The port for the client and server to communicate on (via REST).
#                                 Ignored if BACALHAU_API_PORT environment variable is set. (default 1234)
#       --cacert string           The location of a CA certificate file when self-signed certificates
#                                         are used by the server
#       --insecure                Enables TLS but does not verify certificates
#       --log-mode logging-mode   Log format: 'default','station','json','combined','event' (default default)
#       --repo string             path to bacalhau repo (default "/home/arsen/.bacalhau")
#       --tls                     Instructs the client to use TLS