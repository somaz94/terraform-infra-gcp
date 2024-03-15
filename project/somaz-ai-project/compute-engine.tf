## nerdystar_ai_server ##
resource "google_compute_address" "ai_server_ip" {
  name   = var.ai_server_ip
  region = var.region
}

resource "google_compute_instance" "ai_server" {
  name                      = var.ai_server
  machine_type              = "a2-highgpu-2g" # a2-ultragpu-2g = A100 80G 2개 / a2-highgpu-2g = A100 40G 2개
  labels                    = local.default_labels
  zone                      = "${var.region}-a"
  allow_stopping_for_update = true

  tags = [var.nfs_client]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 100
    }
  }

  metadata = {
    ssh-keys              = "somaz:${file("../../key/ai-server.pub")}"
    install-nvidia-driver = "true"
  }

  network_interface {
    network    = "projects/${var.host_project}/global/networks/${var.shared_vpc}"
    subnetwork = "projects/${var.host_project}/regions/${var.region}/subnetworks/${var.subnet_share}-ai-a"

    access_config {
      ## Include this section to give the VM an external ip ##
      nat_ip = google_compute_address.ai_server_ip.address
    }
  }

  scheduling {
    on_host_maintenance = "TERMINATE" # 또는 "MIGRATE" 대신 "RESTART" 사용
    automatic_restart   = true
    preemptible         = false
  }

  guest_accelerator {
    type  = "nvidia-tesla-a100" # nvidia-a100-80gb = A100 80G / nvidia-tesla-a100 = A100 40G
    count = 2
  }

  depends_on = [google_compute_address.ai_server_ip]

}

## Compute Engine ##
resource "google_compute_address" "django_server_ip" {
  name = var.django_server_ip
}

resource "google_compute_instance" "django_server" {
  name                      = var.django_server
  machine_type              = "n2-standard-2"
  labels                    = local.default_labels
  zone                      = "${var.region}-a"
  allow_stopping_for_update = true

  tags = [var.nfs_client, var.django_server]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 100
    }
  }

  metadata = {
    ssh-keys = "somaz:${file("../../key/django-server.pub")}"
  }

  network_interface {
    network    = "projects/${var.host_project}/global/networks/${var.shared_vpc}"
    subnetwork = "projects/${var.host_project}/regions/${var.region}/subnetworks/${var.subnet_share}-ai-a"

    access_config {
      ## Include this section to give the VM an external ip ##
      nat_ip = google_compute_address.django_server_ip.address
    }
  }

  depends_on = [google_compute_address.django_server_ip]
}

## nerdystar_l4_server_1 ##
resource "google_compute_address" "l4_server_1_ip" {
  name   = var.l4_server_1_ip
  region = var.region
}

resource "google_compute_instance" "l4_server_1" {
  name                      = var.l4_server_1
  machine_type              = "g2-standard-96" # g2-standard-4 = L4 GDDR6 24GB 1개 / g2-standard-24 = L4 GDD6 48GB 2개  / g2-standard-96= L4 GDDR6 24GB 8개=192GB / GPU : https://cloud.google.com/compute/docs/gpus?hl=ko
  labels                    = local.default_labels
  zone                      = "${var.region}-b"
  allow_stopping_for_update = true

  tags = [var.nfs_client, var.ai_server]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 100
    }
  }

  metadata = {
    ssh-keys              = "somaz:${file("../../key/ai-server.pub")}"
    install-nvidia-driver = "true"
  }

  network_interface {
    network    = "projects/${var.host_project}/global/networks/${var.shared_vpc}"
    subnetwork = "projects/${var.host_project}/regions/${var.region}/subnetworks/${var.subnet_share}-nerdystar-ai-a"

    access_config {
      ## Include this section to give the VM an external ip ##
      nat_ip = google_compute_address.l4_server_1_ip.address
    }
  }

  scheduling {
    on_host_maintenance = "TERMINATE" # 또는 "MIGRATE" 대신 "RESTART" 사용
    automatic_restart   = true
    preemptible         = false
  }

  guest_accelerator {
    type  = "nvidia-l4"
    count = 8
  }

  depends_on = [google_compute_address.l4_server_1_ip]

}
