resource "tanzu-mission-control_custom_policy_template" "K8sReplicaLimits" {
  name = "k8sreplicalimits"

  spec {
    object_type   = "ConstraintTemplate"
    template_type = "OPAGatekeeper"

    data_inventory {
      kind    = "ConfigMap"
      group   = "admissionregistration.k8s.io"
      version = "v1"
    }

    data_inventory {
      kind    = "Deployment"
      group   = "extensions"
      version = "v1"
    }

    template_manifest = <<YAML
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sreplicalimits
  annotations:
    metadata.gatekeeper.sh/title: "Replica Limits"
    metadata.gatekeeper.sh/version: 1.0.2
    description: >-
      Requires that objects with the field `spec.replicas` (Deployments,
      ReplicaSets, etc.) specify a number of replicas within defined ranges.
spec:
  crd:
    spec:
      names:
        kind: k8sreplicalimits
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          properties:
            ranges:
              type: array
              description: Allowed ranges for numbers of replicas.  Values are inclusive.
              items:
                type: object
                description: A range of allowed replicas.  Values are inclusive.
                properties:
                  minReplicas:
                    description: The minimum number of replicas allowed, inclusive.
                    type: integer
                  maxReplicas:
                    description: The maximum number of replicas allowed, inclusive.
                    type: integer
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sreplicalimits

        object_name = input.review.object.metadata.name
        object_kind = input.review.kind.kind

        violation[{"msg": msg}] {
            spec := input.review.object.spec
            not input_replica_limit(spec)
            msg := sprintf("The provided number of replicas is not allowed for %v: %v. Allowed ranges: %v", [object_kind, object_name, input.parameters])
        }

        input_replica_limit(spec) {
            provided := spec.replicas
            count(input.parameters.ranges) > 0
            range := input.parameters.ranges[_]
            value_within_range(range, provided)
        }

        value_within_range(range, value) {
            range.minReplicas <= value
            range.maxReplicas >= value
        }
YAML
  }
}
