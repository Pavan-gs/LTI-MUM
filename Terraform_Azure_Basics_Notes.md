
# Terraform Basics on Azure

## 1. What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool used to define, provision, update, and delete cloud infrastructure using declarative configuration files.  
Instead of manually creating resources through a cloud portal, infrastructure is described once in code and managed consistently over time.

Terraform works by:
- Reading configuration files (`.tf`)
- Comparing the desired state with the current state
- Calling cloud provider APIs (Azure in this case)
- Creating, updating, or deleting resources to match the desired state

---

## 2. Why Terraform is Used

- Infrastructure is reproducible and consistent
- Changes are predictable using plans
- Infrastructure definitions can be version-controlled
- Suitable for automation and CI/CD pipelines
- Reduces manual configuration errors

---

## 3. Core Concepts

### Provider
A provider allows Terraform to interact with a cloud platform.
A plugin that knows how to talk to a cloud

Example: azurerm for Azure


Example:
```hcl
provider "azurerm" {
  features {}
}
```

### Resource
A resource represents a cloud object such as a VM, database, or storage account.
A thing Terraform creates
VM, SQL DB, Storage, etc.

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-demo"
  location = "East US"
}
```

### State
Terraform maintains a state file (`terraform.tfstate`) that tracks:
- Resources created
- Resource IDs
- Dependencies

This file allows Terraform to know what already exists.
“Terraform remembers what it creates so it can modify or delete it later.”
---

#### Desired State vs Actual State

Code = desired state
Azure = actual state
Terraform compares both and reconciles differences


## 4. Terraform Folder Structure

Terraform works at a directory level. All `.tf` files in a folder are read together.

Recommended structure:
```
terraform-project/
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfstate
```

File names are for readability only; Terraform merges them internally.

| File              | Purpose                  |
| ----------------- | ------------------------ |
| main.tf           | Main infrastructure code |
| variables.tf      | Input values             |
| outputs.tf        | Display useful outputs   |
| terraform.tfstate | Terraform state (auto)   |


---

## 5. Common Terraform Commands

### Initialize the project
```powershell
terraform init
```
Downloads providers and prepares the directory. Must be run once per project.

### Validate configuration
```powershell
terraform validate
```
Checks syntax and internal consistency.

### Preview changes
```powershell
terraform plan
```
Shows what will be created, modified, or destroyed.
Shows what will change
Safe command
Does NOT create anything

### Apply changes
```powershell
terraform apply
```
Creates or updates resources after confirmation.

## list resources and state
terraform state list
terraform state show resource_name


### Destroy resources
```powershell
terraform destroy
```
Deletes all resources managed in the current state.

---

## 6. Azure Infrastructure Example

### Provider and Resource Group
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-demo"
  location = "East US"
}
```

---

## 7. Virtual Network and Subnet

```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-demo"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-demo"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

---

## 8. Network Interface

```hcl
resource "azurerm_network_interface" "nic" {
  name                = "nic-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
```

---

## 9. Linux Virtual Machine

```hcl
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-demo"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"

  admin_username = "azureuser"
  admin_password = "Password@1234"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
```

---

## 10. Azure SQL Server and Database

```hcl
resource "azurerm_mssql_server" "sqlserver" {
  name                         = "sqlserverdemo12345"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Password@1234"
}

resource "azurerm_mssql_database" "sqldb" {
  name      = "sqldb-demo"
  server_id = azurerm_mssql_server.sqlserver.id
  sku_name  = "Basic"
}
```

---

## 11. ADLS Gen2 Storage Account

```hcl
resource "azurerm_storage_account" "adls" {
  name                     = "adlsdemostorage123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "container" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"
}
```

---

## 12. Moving Data into ADLS

Terraform provisions infrastructure only.  
Data movement is done using other tools such as Azure CLI.

Example:
```powershell
az storage blob upload `
  --account-name adlsdemostorage123 `
  --container-name data `
  --name sample.csv `
  --file C:\temp\sample.csv `
  --auth-mode login
```

---

## 13. Cleanup

```powershell
terraform destroy
```

Deletes all resources created and tracked in the state file.

---

## 14. Key Notes

- Terraform evaluates all `.tf` files in a directory together
- Individual files cannot be executed separately
- State file must be protected and preserved
- Manual changes in the portal can cause drift
- Terraform is best suited for infrastructure provisioning
