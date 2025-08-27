### Kubernetes Job PodFailurePolicy Demo

This snippet demonstrates using `podFailurePolicy` with Kubernetes Job.  
It shows how to pods restarts on node disruptions (spot interruption) while failing on OOM.

### Setup
```sh
./setup.sh
```

### Showcase
```sh
./run.sh
```
- **Normal mode**: Start the Job; a new pod is created and runs normally

- **Spot interruption**: Restart the worker node; a new pod is created and runs normally (`backoffLimit: 6`). Ideally, the node is replaced but whatever :)

- **OOMKilled simulation**: Run a Job configured to exceed memory limits; the pod dies and does not restart.

### Output

```sh
=== Cleanup ===
NAME                    STATUS   ROLES           AGE     VERSION
pfptest-control-plane   Ready    control-plane   7m27s   v1.33.1
pfptest-worker          Ready    <none>          7m18s   v1.33.1
job.batch "pfptest" deleted
node/pfptest-worker already uncordoned

=== Normal run ===
job.batch/pfptest created
NAME            READY   STATUS        RESTARTS   AGE
pfptest-47mqc   1/1     Terminating   0          33s
pfptest-5dhp8   1/1     Running       0          10s
Normal mode... 0
Normal mode... 1
Normal mode... 2
Normal mode... 3
Normal mode... 4
Normal mode... 5
Normal mode... 6
Normal mode... 7
Normal mode... 8
Normal mode... 9

=== Simulate spot eviction (restart worker node) ===
pfptest-worker
NAME            READY   STATUS    RESTARTS   AGE
pfptest-52qdx   1/1     Running   0          10s
pfptest-5dhp8   0/1     Unknown   0          41s
Found 2 pods, using pod/pfptest-52qdx
Normal mode... 0
Normal mode... 1
Normal mode... 2
Normal mode... 3
Normal mode... 4
Normal mode... 5
Normal mode... 6
Normal mode... 7
Normal mode... 8
Normal mode... 9

=== Simulate OOM (should fail) ===
job.batch "pfptest" deleted
job.batch/pfptest created
job.batch/pfptest condition met
NAME            READY   STATUS        RESTARTS   AGE
pfptest-52qdx   1/1     Terminating   0          21s
pfptest-bx6pd   0/1     OOMKilled     0          11s
```