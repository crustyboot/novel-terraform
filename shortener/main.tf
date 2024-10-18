/*
Module that accepts a list of strings and loops through them to create a string within
a defined maximum length.
If the string is too long, it will shorten the words to fit the maximum length, if possible.
If there are not enough characters to shorten the words, it will return an error.
If the string is already within the requirements, none of the words will be shortened.

EXAMPLE:
  name_parts        = ["three", "little", "pigs"]
  max_length        = 12
  minimum_word_size = 3
  separator         = "-"

OUTPUT:
  "thr-litt-pig"

HOW IT WORKS:
First, it calculates the total length of the string with separators included.
Then, it determines if the string needs to be shortened.

Length of each word stored in local.lengths
> local.lengths
  [
    5,
    6,
    4,
  ]

Build the full string with separators and determine length, stored in local.full_length,
e.g. length("three-little-pigs") = 17
> local.full_length
  17

Next determine if the strings needs to be shortened, and if there are enough characters to shorten the string.

If the string needs to be shortened, it will determine how many characters can be removed from each word.
The values correspond to the TOTAL POSSIBLE number of characters that can be removed from each word.
>local.avail_to_give
  [
    2, <-- "three" can be shortened by 2 characters
    3, <-- "little" can be shortened by 3 characters
    1, <-- "pigs" can be shortened by 1 character
  ]

Now we determine the order in which the words will be shortened. Always starting with the first word, and looping through the list of words.
This will generate a matrix of the order in which the words will be shortened. The values represent the indices of the words that can be shortened.
>local.trim_order
  [
    [     0,     1,     2, ],
    [     0,     1,  null, ],
    [  null,     1,  null, ],
    [  null,  null,  null, ],
    [  null,  null,  null, ],
  ]

This matrix is then flattened and compacted to remove any null values, and then sliced to the number of characters that need to be removed.
>local.trims_needed
  tolist([
    "0",
    "1",
    "2",
    "0",
    "1",
  ])

The next step is to determine how many times each word will be shortened. A matrix is created with the same dimensions as the original list of words.
>local.trims_per_word
  [
    [ 1, 0, 0, 1, 0, ], <-- "three" will be shortened twice
    [ 0, 1, 0, 0, 1, ], <-- "little" will be shortened twice
    [ 0, 0, 1, 0, 0, ], <-- "pigs" will be shortened once
  ]

Using the matrix above, we can determine the new length of each word after shortening.
>local.shortened_lengths
  [
    3, <-- "three" will be shortened to "thr"
    4, <-- "little" will be shortened to "litt"
    3, <-- "pigs" will be shortened to "pig"
  ]

Finally, we can generate the shortened list of words and join them with the separator.
>local.shortened_name
  "thr-litt-pig"
*/

variable "name_parts" {
  description = "List of strings to shorten and join together with the separator to form the final string. The order of the strings will be preserved."
  type        = list(string)
}


variable "max_length" {
  default     = 12
  description = "Maximum length of the final string"
  type        = number
}

variable "minimum_word_size" {
  default     = "3"
  description = "Minimum size of a word in the final string. If a word is shorter than this, it will not be shortened."
  type        = string
}

variable "separator" {
  default     = "-"
  description = "Separator to use between words. For no separator, use an empty string."
  type        = string
}

locals {
  range = range(length(var.name_parts))

  lengths = [for i in var.name_parts : length(i)]

  full_length = sum(concat(local.lengths, [(length(var.name_parts) - 1) * length(var.separator)]))

  chars_to_trim = local.full_length - var.max_length > 0 ? local.full_length - var.max_length : 0

  shorting_needed = local.chars_to_trim > 0

  avail_to_give = [for i in local.lengths : (i > var.minimum_word_size ? i - var.minimum_word_size : 0)]

  can_shorten = sum(local.avail_to_give) >= local.chars_to_trim

  run_shortener = local.shorting_needed && local.can_shorten

  trim_order = [for i in range(local.chars_to_trim) : ([for x in range(length(local.avail_to_give)) : (local.avail_to_give[x] - i > 0 ? x : null)])]

  trims_needed = local.run_shortener ? slice(compact(concat(local.trim_order...)), 0, local.chars_to_trim) : null

  trims_per_word = local.run_shortener ? [for i in local.range : ([for x in local.trims_needed : (i == tonumber(x) ? 1 : 0)])] : null

  shortened_lengths = local.run_shortener ? [for i in local.range : (local.lengths[i] - sum(local.trims_per_word[i]))] : null

  shortened_name_list = local.run_shortener ? [for i in local.range : (substr(var.name_parts[i], 0, local.shortened_lengths[i]))] : null

  shortened_name = local.run_shortener ? join(var.separator, local.shortened_name_list) : join(var.separator, var.name_parts)
}

output "name" {
  description = "Final shortened name"
  value       = local.shortened_name

  precondition {
    condition     = local.can_shorten
    error_message = <<-EOT
    Unable to shorten given constraints of 'minimum_word_size' = ${var.minimum_word_size} and 'max_length' = ${var.max_length}.
    Characters needed to trim    = ${local.chars_to_trim}
    Characters available to trim = ${sum(local.avail_to_give)}
    EOT
  }
}

output "debug" {
  description = "Debug output"
  value = {
    name_parts          = var.name_parts,
    range               = local.range,
    lengths             = local.lengths,
    full_length         = local.full_length,
    chars_to_trim       = local.chars_to_trim,
    shorting_needed     = local.shorting_needed,
    avail_to_give       = local.avail_to_give,
    can_shorten         = local.can_shorten,
    trim_order          = local.trim_order,
    trims_needed        = local.trims_needed,
    trims_per_word      = local.trims_per_word,
    shortened_lengths   = local.shortened_lengths,
    shortened_name_list = local.shortened_name_list,
    shortened_name      = local.shortened_name
  }
}
