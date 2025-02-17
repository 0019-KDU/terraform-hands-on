# resource "local_file" "example1" {
#   content = "This is an example file."
#   filename = "${path.module}/example1.txt"
# }

# resource "local_file" "example2" {
#   content = "t"
#   filename = "${path.module}/example2.txt"
# }

resource "local_sensitive_file" "tf_sensitive" {
  content = "This is a sensitive example file."
  filename = "${path.module}/example3.txt"
  
}