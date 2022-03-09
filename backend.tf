terraform {
  backend "s3" {
    bucket = "mybucket" #bucket que sera armazenado
    key    = "path/to/my/key" #caminho dentro do bucket
    region = "us-east-1" 
    dynamodb_table = ""
    profile = ""
  }
}
