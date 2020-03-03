# terraform-aws-icon-registration

## Features

This module helps with registering a node on the ICON Blockchain. It does three main things.

- Creates an elastic IP that will be your main IP that your node will use to run
- Puts the necessary details.json file in a bucket publicly accessible
- Outputs the commands you need to run in preptools

**Make sure you have 2000 ICX registration fee in your wallet for mainnet and you have testnet tokens for testnet**

Future versions will run preptools automatically and will be idempotent (ie can run as many times as you want without breaking things).

## Using this module

Fill out the appropriate values in `terraform.tfvars.example` then move to `terraform.tfvars` if running directly.

## Terraform Versions

For Terraform v0.12.0+

## Usage

```
module "this" {
    source = "github.com/robc-io/terraform-aws-icon-registration"

}
```
## Examples

- [defaults](https://github.com/robc-io/terraform-aws-icon-registration/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| local | n/a |
| null | n/a |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| bucket | The name of the bucket to make | `string` | `""` | no |
| facebook | Link to social media account - https://... | `string` | `""` | no |
| github | Link to social media account - https://... | `string` | `""` | no |
| ip | Optional if you are registering an IP from a different network | `string` | n/a | yes |
| keybase | Link to social media account - https://... | `string` | `""` | no |
| keystore\_password | The keystore password | `string` | n/a | yes |
| keystore\_path | the path to your keystore | `string` | n/a | yes |
| logo\_1024 | Path to png logo | `string` | `""` | no |
| logo\_256 | Path to png logo | `string` | `""` | no |
| logo\_svg | Path to svg logo | `string` | `""` | no |
| network\_name | mainnet or testnet - Don't mess this up!!!!!!!! | `string` | `"mainnet"` | no |
| organization\_city | No qualifiers | `string` | `""` | no |
| organization\_country | This needs to be three letter country code per https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3 | `string` | `""` | no |
| organization\_email | Needs to be real email | `string` | `""` | no |
| organization\_name | Any string - your team name | `string` | `""` | no |
| organization\_website | Needs to begin in https / http - can be google... | `string` | `""` | no |
| reddit | Link to social media account - https://... | `string` | `""` | no |
| region | The region you are running your server - no constraints | `string` | `""` | no |
| server\_type | Link to social media account - https://... | `string` | `"cloud"` | no |
| steemit | Link to social media account - https://... | `string` | `""` | no |
| tags | Additional tags to include | `map(string)` | `{}` | no |
| telegram | Link to social media account - https://... | `string` | `""` | no |
| twitter | Link to social media account - https://... | `string` | `""` | no |
| wechat | Link to social media account - https://... | `string` | `""` | no |
| youtube | Link to social media account - https://... | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| details\_endpoint | n/a |
| details\_values | n/a |
| ip | n/a |
| network\_name | n/a |
| public\_ip | n/a |
| registration\_command | n/a |
| registration\_json | n/a |
| update\_registration\_command | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing
This module has been packaged with terratest tests

To run them:

1. Install Go
2. Run `make test-init` from the root of this repo
3. Run `make test` again from root

## Authors

Module managed by [robc-io](github.com/robc-io)

## Credits

- [Anton Babenko](https://github.com/antonbabenko)

## License

Apache 2 Licensed. See LICENSE for full details.