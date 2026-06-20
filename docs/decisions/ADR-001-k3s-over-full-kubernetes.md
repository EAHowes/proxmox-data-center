# ADR-001: Use k3s over full Kubernetes

As a much lighter version of k8s, k3s allowes for more system resources to be deicated to software running on the machine.

# Comparison

| | k3s | k8s |
|-----------|---|---|
| RAM | 500 MB | 4 GB |
| State storage | SQLite | etcd |
| Deployment | Single Binary | Many configurable componenets |

