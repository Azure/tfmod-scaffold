/*
THIS FILE IS GENERATED BY TFMOD-SCAFFOLD, PLEASE DO NOT MODIFY IT.
IF YOU WANT TO USE A CUSTOMIZED CONFIGURATION, PLEASE CREATE YOUR OWN AND
SET THIS FILE'S PATH TO $TFLINT_CONFIG ENVVIRONMENT VARIABLE.
*/

plugin "azurerm" {
  enabled = true
  version = "0.23.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

plugin "basic-ext" {
  enabled     = true
  version     = "0.3.1"
  source      = "github.com/Azure/tflint-ruleset-basic-ext"
  signing_key = <<-KEY
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=nfI3
-----END PGP PUBLIC KEY BLOCK-----
    KEY
}

plugin "azurerm-ext" {
  enabled     = true
  version     = "0.4.0"
  source      = "github.com/Azure/tflint-ruleset-azurerm-ext"
  signing_key = <<-KEY
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=nfI3
-----END PGP PUBLIC KEY BLOCK-----
    KEY
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_empty_list_equality" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_module_version" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}

rule "terraform_locals_order" {
  enabled = false
}

rule "terraform_output_order" {
  enabled = false
}

rule "terraform_output_separate" {
  enabled = false
}

rule "terraform_variable_nullable_false" {
  enabled = false
}

rule "terraform_variable_order" {
  enabled = false
}

rule "terraform_variable_separate" {
  enabled = false
}

rule "terraform_resource_data_arg_layout" {
  enabled = false
}

rule "azurerm_arg_order" {
  enabled = false
}

rule "azurerm_resource_tag" {
  enabled = true
}

rule "terraform_count_index_usage" {
  enabled = false
}

rule "terraform_heredoc_usage" {
  enabled = true
}

rule "terraform_module_provider_declaration" {
  enabled = true
}

rule "terraform_required_providers_declaration" {
  enabled = true
}

rule "terraform_required_version_declaration" {
  enabled = true
}

rule "terraform_sensitive_variable_no_default" {
  enabled = false
}

rule "terraform_versions_file" {
  enabled = true
}

rule "azurerm_automation_account_invalid_sku_name" {
  enabled = true
}

rule "azurerm_batch_account_invalid_name" {
  enabled = true
}

rule "azurerm_batch_application_invalid_account_name" {
  enabled = true
}

rule "azurerm_batch_application_invalid_name" {
  enabled = true
}

rule "azurerm_batch_certificate_invalid_account_name" {
  enabled = true
}

rule "azurerm_batch_pool_invalid_account_name" {
  enabled = true
}

rule "azurerm_batch_pool_invalid_name" {
  enabled = true
}

rule "azurerm_bot_channel_directline_invalid_bot_name" {
  enabled = true
}

rule "azurerm_bot_channel_directline_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_bot_channel_email_invalid_bot_name" {
  enabled = true
}

rule "azurerm_bot_channel_email_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_bot_channel_ms_teams_invalid_bot_name" {
  enabled = true
}

rule "azurerm_bot_channel_ms_teams_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_bot_channel_slack_invalid_bot_name" {
  enabled = true
}

rule "azurerm_bot_channel_slack_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_bot_channels_registration_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_bot_connection_invalid_bot_name" {
  enabled = true
}

rule "azurerm_bot_connection_invalid_name" {
  enabled = true
}

rule "azurerm_bot_connection_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_bot_web_app_invalid_name" {
  enabled = true
}

rule "azurerm_bot_web_app_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_cdn_endpoint_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_cdn_profile_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_cognitive_account_invalid_name" {
  enabled = true
}

rule "azurerm_container_registry_invalid_name" {
  enabled = true
}

rule "azurerm_container_registry_webhook_invalid_name" {
  enabled = true
}

rule "azurerm_container_registry_webhook_invalid_registry_name" {
  enabled = true
}

rule "azurerm_cosmosdb_account_invalid_name" {
  enabled = true
}

rule "azurerm_cosmosdb_account_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_cosmosdb_cassandra_keyspace_invalid_account_name" {
  enabled = true
}

rule "azurerm_cosmosdb_cassandra_keyspace_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_cosmosdb_gremlin_database_invalid_account_name" {
  enabled = true
}

rule "azurerm_cosmosdb_gremlin_database_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_cosmosdb_gremlin_graph_invalid_account_name" {
  enabled = true
}

rule "azurerm_cosmosdb_gremlin_graph_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_cosmosdb_mongo_collection_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_cosmosdb_mongo_database_invalid_account_name" {
  enabled = true
}

rule "azurerm_cosmosdb_mongo_database_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_cosmosdb_sql_container_invalid_account_name" {
  enabled = true
}

rule "azurerm_cosmosdb_sql_container_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_cosmosdb_sql_database_invalid_account_name" {
  enabled = true
}

rule "azurerm_cosmosdb_sql_database_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_cosmosdb_table_invalid_account_name" {
  enabled = true
}

rule "azurerm_cosmosdb_table_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_data_factory_dataset_mysql_invalid_linked_service_name" {
  enabled = true
}

rule "azurerm_data_factory_dataset_mysql_invalid_name" {
  enabled = true
}

rule "azurerm_data_factory_dataset_postgresql_invalid_linked_service_name" {
  enabled = true
}

rule "azurerm_data_factory_dataset_postgresql_invalid_name" {
  enabled = true
}

rule "azurerm_data_factory_dataset_sql_server_table_invalid_linked_service_name" {
  enabled = true
}

rule "azurerm_data_factory_dataset_sql_server_table_invalid_name" {
  enabled = true
}

rule "azurerm_data_factory_invalid_name" {
  enabled = true
}

rule "azurerm_data_factory_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_data_factory_linked_service_data_lake_storage_gen2_invalid_name" {
  enabled = true
}

rule "azurerm_data_factory_linked_service_mysql_invalid_name" {
  enabled = true
}

rule "azurerm_data_factory_linked_service_postgresql_invalid_name" {
  enabled = true
}

rule "azurerm_data_factory_linked_service_sql_server_invalid_name" {
  enabled = true
}

rule "azurerm_data_factory_pipeline_invalid_name" {
  enabled = true
}

rule "azurerm_databricks_workspace_invalid_managed_resource_group_name" {
  enabled = true
}

rule "azurerm_databricks_workspace_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_dev_test_policy_invalid_name" {
  enabled = true
}

rule "azurerm_frontdoor_firewall_policy_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_frontdoor_invalid_name" {
  enabled = true
}

rule "azurerm_frontdoor_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_healthcare_service_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_hpc_cache_invalid_name" {
  enabled = true
}

rule "azurerm_iothub_endpoint_storage_container_invalid_name" {
  enabled = true
}

rule "azurerm_iothub_route_invalid_name" {
  enabled = true
}

rule "azurerm_key_vault_invalid_name" {
  enabled = true
}

rule "azurerm_key_vault_invalid_sku_name" {
  enabled = true
}

rule "azurerm_kubernetes_cluster_invalid_name" {
  enabled = true
}

rule "azurerm_maps_account_invalid_sku_name" {
  enabled = true
}

rule "azurerm_nat_gateway_invalid_sku_name" {
  enabled = true
}

rule "azurerm_netapp_account_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_netapp_pool_invalid_name" {
  enabled = true
}

rule "azurerm_netapp_pool_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_netapp_snapshot_invalid_pool_name" {
  enabled = true
}

rule "azurerm_netapp_snapshot_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_netapp_snapshot_invalid_volume_name" {
  enabled = true
}

rule "azurerm_netapp_volume_invalid_name" {
  enabled = true
}

rule "azurerm_netapp_volume_invalid_pool_name" {
  enabled = true
}

rule "azurerm_netapp_volume_invalid_resource_group_name" {
  enabled = true
}

rule "azurerm_notification_hub_namespace_invalid_sku_name" {
  enabled = true
}

rule "azurerm_postgresql_configuration_invalid_name" {
  enabled = true
}

rule "azurerm_postgresql_database_invalid_name" {
  enabled = true
}

rule "azurerm_postgresql_firewall_rule_invalid_name" {
  enabled = true
}

rule "azurerm_redis_cache_invalid_sku_name" {
  enabled = true
}

rule "azurerm_relay_namespace_invalid_sku_name" {
  enabled = true
}

rule "azurerm_storage_account_invalid_resource_group_name" {
  enabled = true
}