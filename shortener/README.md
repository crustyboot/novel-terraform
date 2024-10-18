<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_max_length"></a> [max\_length](#input\_max\_length) | Maximum length of the final string | `number` | `12` | no |
| <a name="input_minimum_word_size"></a> [minimum\_word\_size](#input\_minimum\_word\_size) | Minimum size of a word in the final string. If a word is shorter than this, it will not be shortened. | `string` | `"3"` | no |
| <a name="input_name_parts"></a> [name\_parts](#input\_name\_parts) | List of strings to shorten and join together with the separator to form the final string. The order of the strings will be preserved. | `list(string)` | n/a | yes |
| <a name="input_separator"></a> [separator](#input\_separator) | Separator to use between words. For no separator, use an empty string. | `string` | `"-"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_debug"></a> [debug](#output\_debug) | Debug output |
| <a name="output_name"></a> [name](#output\_name) | Final shortened name |
<!-- END_TF_DOCS -->