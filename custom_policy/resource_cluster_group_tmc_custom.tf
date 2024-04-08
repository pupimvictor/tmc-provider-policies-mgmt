resource "tanzu-mission-control_custom_policy" "cgcustom" {
  name = "test-custom-cg-tf"

  scope {
    cluster_group {
      cluster_group = "bdc-all-clusters"
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
