resource "juju_model" "sdcore" {
  name = var.model_name
}

resource "juju_application" "gnbsim" {
  name = "gnbsim"
  model = var.model_name

  charm {
    name = "sdcore-gnbsim-k8s"
    channel = var.channel
  }

  units = 1
  trust = true
}

module "mongodb-k8s" {
  source     = "gatici/mongodb-k8s/juju"
  version    = "1.0.2"
  model_name = var.model_name
}

module "self-signed-certificates" {
  source     = "gatici/self-signed-certificates/juju"
  version    = "1.0.3"
  model_name = var.model_name
}

module "sdcore-nrf-k8s" {
  source  = "gatici/sdcore-nrf-k8s/juju"
  version = "1.0.0"
  model_name = var.model_name
  certs_application_name = var.certs_application_name
  db_application_name = var.db_application_name
  channel = var.channel
}

module "sdcore-amf-k8s" {
  source  = "gatici/sdcore-amf-k8s/juju"
  version = "1.0.0"
  model_name = var.model_name
  certs_application_name = var.certs_application_name
  db_application_name = var.db_application_name
  channel = var.channel
  nrf_application_name = var.nrf_application_name
}

resource "juju_integration" "gnbsim-amf" {
  model = var.model_name

  application {
    name     = juju_application.gnbsim.name
    endpoint = "fiveg-n2"
  }

  application {
    name     = var.amf_application_name
    endpoint = "fiveg-n2"
  }
}

