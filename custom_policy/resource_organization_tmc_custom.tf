resource "tanzu-mission-control_custom_policy" "orgcustom" {
  name = "test-custom-org-template-tf"

  scope {
    organization {
      organization = "6d895d4e-36ca-4931-9e63-007463d6397d"
    }
  }

  spec {
    input {
      custom {
        template_name = "k8sreplicalimits"
        audit         = true

        parameters = jsonencode({
          ranges = [
            {
              minReplicas = 3
              maxReplicas = 7
            }
          ]
        })


        target_kubernetes_resources {
          api_groups = [
            "apps",
          ]
          kinds = [
            "Deployment"
          ]
        }

        target_kubernetes_resources {
          api_groups = [
            "apps",
          ]
          kinds = [
            "StatefulSet",
          ]
        }
      }
    }

  #   namespace_selector {
  #     match_expressions {
  #       key      = "<label-selector-requirement-key-1>"
  #       operator = "<label-selector-requirement-operator>"
  #       values = [
  #         "<label-selector-requirement-value-1>",
  #         "<label-selector-requirement-value-2>"
  #       ]
  #     }
  #     match_expressions {
  #       key      = "<label-selector-requirement-key-2>"
  #       operator = "<label-selector-requirement-operator>"
  #       values   = []
  #     }
  #   }
  }
}
