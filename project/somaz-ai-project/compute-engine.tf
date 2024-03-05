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
