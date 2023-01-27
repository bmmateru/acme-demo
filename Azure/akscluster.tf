resource "azurerm_resource_group" "rg" {
  name     = "acme_prod"
  location = "westus2"
}

# Create Sample Azure Cluster

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "bmateru-aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "wosia"
  
  

  default_node_pool {
    name       = "default"
    node_count = "1"
    vm_size    = "standard_a2_v2"
  }

  identity {
    type = "SystemAssigned"
  }


 network_profile {
    network_plugin      = "azure"
    load_balancer_sku = "standard"
    load_balancer_profile {
      managed_outbound_ip_count = 1
    }
  }

}
# Outputs

resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.cluster]
  filename     = "kubeconfig"
  content      = azurerm_kubernetes_cluster.cluster.kube_config_raw
}


