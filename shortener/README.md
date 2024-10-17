<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_max_length"></a> [max\_length](#input\_max\_length) | how long the string can be | `number` | `12` | no |
| <a name="input_minimum_word_size"></a> [minimum\_word\_size](#input\_minimum\_word\_size) | Minimum size of that a word can be in the final string. If a word is shorter than this, it will not be shortened. | `string` | `"3"` | no |
| <a name="input_name_parts"></a> [name\_parts](#input\_name\_parts) | n/a | `list(string)` | n/a | yes |
| <a name="input_separator"></a> [separator](#input\_separator) | Separator to use between words | `string` | `"-"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_debug"></a> [debug](#output\_debug) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->