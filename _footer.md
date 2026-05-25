## AVM Deviations

This module is **AVM-aligned** but not AVM-certified. The following deviations from the [AVM Terraform specification](https://azure.github.io/Azure-Verified-Modules/specs/terraform/) are intentional and documented here.

| Deviation | AVM Ref | Reason |
|---|---|---|
| Provider: `integrations/github` instead of `azurerm`/`azapi` | TFFR3 | This is a GitHub resource module, not an Azure module. The `microsoft/power-platform` provider is not applicable. |
| No `tags` variable | Interface spec — tags | GitHub repositories do not support Azure-style resource tags. The AVM tags interface is not applicable. |
| Deprecated fields excluded (`vulnerability_alerts`, `pages`, `has_downloads`) | — | These provider attributes are deprecated. Use the dedicated `github_repository_vulnerability_alerts` and `github_repository_pages` Terraform resources instead. |
| Name validation stricter than provider | — | The `name` variable rejects leading `.` (e.g., `.github`). This is an intentional governance constraint; create special-purpose repositories outside this module if needed. |
| No telemetry beacon | TELEM1 | This module is not published under the `Azure/` Terraform registry namespace and is not subject to AVM certification requirements. |
