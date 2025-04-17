# Portainer Agent

[Portainer Agent](https://www.portainer.io) is a lightweight companion to the Portainer Server that runs inside your environment and relays instructions from the Portainer Server to the environment it's running in.

## Introduction

This chart bootstraps a Portainer Agent deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `portainer-agent`:

```bash
helm repo add portainer https://portainer.github.io/k8s/
helm repo update
helm install portainer-agent portainer/portainer-agent
```

## Uninstalling the Chart

To uninstall/delete the `portainer-agent` deployment:

```bash
helm delete portainer-agent
```

## Configuration

The following table lists the configurable parameters of the Portainer Agent chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `deploymentMode` | Deployment mode: "agent", "edge", or "edge-async" | `"agent"` |
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `"portainerci/agent"` |
| `image.tag` | Image tag | `"develop"` |
| `image.pullPolicy` | Image pull policy | `"Always"` |
| `edge.enabled` | Enable edge mode | `false` |
| `edge.id` | Edge ID | `""` |
| `edge.key` | Edge key | `""` |
| `service.type` | Service type | `"ClusterIP"` |
| `service.port` | Service port | `9001` |
| `service.nodePort` | Node port (for NodePort type) | `30775` |
| `feature.flags` | Additional feature flags | `[]` |
| `extraEnv` | Additional environment variables | `[]` |
| `ingress.enabled` | Enable ingress | `false` |
| `resources` | Resource requests/limits | `{}` |

### Edge Mode Configuration

For edge mode deployments, you need to set the following values:

```yaml
deploymentMode: "edge"  # or "edge-async"
edge:
  id: "your-edge-id"
  key: "your-edge-key"
```

### Additional Environment Variables

You can add custom environment variables using the `extraEnv` parameter:

```yaml
extraEnv:
  - name: CUSTOM_VAR
    value: "custom_value"
  - name: SECRET_VAR
    valueFrom:
      secretKeyRef:
        name: my-secret
        key: my-key
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 