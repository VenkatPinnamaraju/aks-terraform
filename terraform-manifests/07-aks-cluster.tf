resource "azurerm_kubernetes_cluster" "aks_cluster" {
  dns_prefix          = "${azurerm_resource_group.ven_rg.name}"
  location            = azurerm_resource_group.ven_rg.location
  name                = "${azurerm_resource_group.ven_rg.name}-cluster"
  resource_group_name = azurerm_resource_group.ven_rg.name
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.ven_rg.name}-nrg"


  default_node_pool {
    name       = "systempool"
    vm_size    = "Standard_DS2_v2"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type           = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = var.environment
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
    tags = {
      "nodepool-type" = "system"
      "environment"   = var.environment
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }    
  }

# Identity (System Assigned or Service Principal)
  identity { type = "SystemAssigned" }

# Add On Profiles
  

# RBAC and Azure AD Integration Block


# Windows Admin Profile
windows_profile {
  admin_username            = var.windows_admin_username
  admin_password            = var.windows_admin_password
}

# Linux Profile


# Network Profile
network_profile {
  load_balancer_sku = "Standard"
  network_plugin = "azure"
}

# AKS Cluster Tags 
tags = {
  Environment = var.environment
}


}