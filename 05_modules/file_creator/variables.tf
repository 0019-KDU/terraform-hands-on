variable "file1_content" {
  description = "Content for file 1"
  type = string
  default = "This is file 1 content"
}

variable "file2_content" {
  description = "Content for file 2"
  type = string
  default = "This is file 2 content"
}

variable "filename_1" {
  type = string
  description = "Name of file 1"
  default = "file_1.txt"
}

variable "filename_2" {
  type = string
  description = "Name of file 2"
  default = "file_2.txt"
}