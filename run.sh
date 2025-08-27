#!/bin/bash

set -e

NODE="pfptest-worker"

echo "=== Cleanup ==="
kubectl get nodes
kubectl delete job pfptest --ignore-not-found
kubectl uncordon $NODE
sleep 10


echo ""
echo "=== Normal run ==="
kubectl apply -f job-normal.yaml
sleep 10
kubectl get pods -l job-name=pfptest
kubectl logs job/pfptest

# === Normal run ===
# job.batch/pfptest created
# NAME            READY   STATUS    RESTARTS   AGE
# pfptest-w465j   1/1     Running   0          5s
# Normal mode... 0
# Normal mode... 1
# Normal mode... 2
# Normal mode... 3
# Normal mode... 4

# After restarting the node (kind of spot instance interruption), the Job should continue
echo ""
echo "=== Simulate spot eviction (restart worker node) ==="
docker restart pfptest-worker
sleep 20
kubectl get pods -l job-name=pfptest
kubectl logs job/pfptest

# NAME            READY   STATUS    RESTARTS   AGE
# pfptest-98mw9   0/1     Unknown   0          41s
# pfptest-c28p2   1/1     Running   0          10s
# Found 2 pods, using pod/pfptest-c28p2
# Normal mode... 0
# Normal mode... 1
# Normal mode... 2
# Normal mode... 3
# Normal mode... 4
# Normal mode... 5
# Normal mode... 6
# Normal mode... 7
# Normal mode... 8
# Normal mode... 9

echo ""
echo "=== Simulate OOM (should fail) ==="
kubectl delete job pfptest
kubectl apply -f job-oom.yaml
sleep 10
kubectl wait --for=condition=Failed job/pfptest --timeout=180s
kubectl get pods -l job-name=pfptest

# NAME            READY   STATUS        RESTARTS   AGE
# pfptest-rk5pc   1/1     Terminating   0          33s
# pfptest-zfk85   0/1     OOMKilled     0          23s