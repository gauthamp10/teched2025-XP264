/*
https://stackoverflow.com/questions/55679852/relative-path-in-local-exec
https://stackoverflow.com/questions/76145479/why-does-my-shell-script-fail-with-exit-code-141-when-running-with-busybox-ash
*/
// https://stackoverflow.com/questions/57454591/how-can-i-load-input-data-from-a-file-in-terraform
// https://stackoverflow.com/questions/77882605/using-resource-local-file-in-terraform-with-atlantis
// https://containersolutions.github.io/terraform-examples/examples/local/local.html
// https://stackoverflow.com/questions/67937425/terraform-how-to-make-the-local-file-resource-to-be-recreated-with-every-te
//

/*


# https://www.gnu.org/software/gawk/manual/html_node/Print-Examples.html
# https://stackoverflow.com/questions/40321035/remove-escape-sequence-characters-like-newline-tab-and-carriage-return-from-jso
#     jq -r '.spec.parameters.allow_access | gsub("[\\n\\t]"; ";") '


locals {

  // add macos-latest runners and solinas runners addresses
  // https://mxtoolbox.com/subnetcalculator.aspx
  // 130.214.104.0/24 is the CI/DR range for the SAP Cloud Connector
  //
  allow_access = local.egress_ips

}

output "allow_access" {
	value = local.allow_access
}


locals {
//  egress_ips = format("%s,%s", data.shell_script.egress_ips.output["allow_access"], var.POSTGRES_ALLOW_ACCESS)
  egress_ips = format("%s,%s", "${local.shoot_info_data_egressCIDRs}", var.POSTGRES_ALLOW_ACCESS)
}


# jsondecode(module.runtime_context.PostgreSQL["spec"]).parameters.allow_access
output "egress_ips" {
  value= local.egress_ips
}

/*

# https://gist.github.com/yokawasa/5358e79636d480274b8731a050ff5a98
# https://registry.terraform.io/providers/scottwinkler/shell/latest/docs/resources/shell_script_resource
# https://registry.terraform.io/providers/scottwinkler/shell/latest/docs/data-sources/shell_script
#
data "shell_script" "egress_ips" {
    depends_on = [ 
        terraform_data.provider_context,
        data.kubernetes_config_map_v1.shoot_info
    ]

    lifecycle_commands {
        //read = file("${path.module}/scripts/egress_ips.sh")
       read = <<EOF
         (
        set -e -o pipefail ;\

        if [ "$ALLOW_ACCESS" = "" ]
        then

        ZONES=$(./kubectl get nodes --kubeconfig $KUBECONFIG -o 'custom-columns=NAME:.metadata.name,REGION:.metadata.labels.topology\.kubernetes\.io/region,ZONE:.metadata.labels.topology\.kubernetes\.io/zone' -o json | jq -r '.items[].metadata.labels["topology.kubernetes.io/zone"]' | sort | uniq)
        echo $ZONES

        for zone in $ZONES; do
        overrides="{ \"apiVersion\": \"v1\", \"spec\": { \"nodeSelector\": { \"topology.kubernetes.io/zone\": \"$zone\" } } }"
        echo | ./kubectl run --kubeconfig $KUBECONFIG --timeout=15m --wait -i --tty curl --image=everpeace/curl-jq --restart=Never  --overrides="$overrides" --rm --command -- curl -s http://ifconfig.me/ip >> temp_cidrs.txt 2>/dev/null
        
        cat temp_cidrs.txt
        sleep 1
        done
        cat temp_cidrs.txt
        CLUSTER_IPS=$(awk '{gsub("pod \"curl\" deleted", "", $0); print}' temp_cidrs.txt)
        rm temp_cidrs.txt
        
        echo $CLUSTER_IPS > egress_cidrs.txt
        
        # https://stackoverflow.com/questions/40321035/remove-escape-sequence-characters-like-newline-tab-and-carriage-return-from-jso
        #
        IPS=$(echo $CLUSTER_IPS | jq -r -R '. | gsub("[ ]"; ", ") ')

        #PostgreSQL=$input
        #echo $(jq -r '.' <<< $PostgreSQL)
        #echo $PostgreSQL | jq -r --arg ips "$IPS" '.spec.parameters |= . + { region: .region, allow_access: $ips }'

        echo $input | jq -r --arg ips "$IPS" '.spec.parameters |= . + { region: .region, allow_access: $ips }'
        echo "{\"allow_access\": \"$IPS\"}"

        else
          echo "{\"allow_access\": \"$ALLOW_ACCESS\"}"
        fi        
         )
       EOF

    }

    interpreter = ["/bin/bash", "-c"]

    sensitive_environment = {
    }

    environment = {
      KUBECONFIG="kubeconfig-headless.yaml"
      NAMESPACE="quovadis-btp"
      ALLOW_ACCESS="${local.shoot_info_data_egressCIDRs}"

      input = nonsensitive(
        jsonencode({
          "apiVersion": "services.cloud.sap.com/v1",
          "kind": "ServiceInstance",
          "metadata": {
              "name": "postgresql"
          },
          "spec": {
              "serviceOfferingName": "postgresql-db",
              "servicePlanName": "${var.BTP_POSTGRESQL_PLAN}",
              "parameters": {
                  "region": "${local.postgresql_region}",
                  "allow_access": ""
              }
          } 
        })
      )  
    }
}
*/

