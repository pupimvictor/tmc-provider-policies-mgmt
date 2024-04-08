resource "tanzu-mission-control_custom_policy" "clustercustom" {
  name = "test-template-cluster-tf"

  scope {
    cluster {
      management_cluster_name = "attached"
      provisioner_name        = "attached"
      name                    = "az-sbx-wl"
    }
  }


  spec {
    input {
      custom {
        template_name = "k8sreplicalimits"
        audit         = false

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

    # namespace_selector {
    #   match_expressions {
    #     key      = "<label-selector-requirement-key-1>"
    #     operator = "<label-selector-requirement-operator>"
    #     values = [
    #       "<label-selector-requirement-value-1>",
    #       "<label-selector-requirement-value-2>"
    #     ]
    #   }
    #   match_expressions {
    #     key      = "<label-selector-requirement-key-2>"
    #     operator = "<label-selector-requirement-operator>"
    #     values   = []
    #   }
    # }
  }
}
