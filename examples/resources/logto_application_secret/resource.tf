resource "logto_application_secret" "example" {
  application_id = logto_application.example.id
  name           = "gitops"
}
