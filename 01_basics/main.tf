# simple file resource
resource "local_file" "tf_example1" {
  content  = "Hello, World!...chiradev"
  filename = "${path.module}/example-${count.index}.txt"
  count = 2
}

resource "local_sensitive_file" "tf_example2" {
  content = "foo..!"
  filename = "${path.module}/foo.txt"
}