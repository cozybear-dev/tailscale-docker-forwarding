resource "tailscale_acl" "default_acl" {
  acl = jsonencode({
    tagOwners : {
      "tag:home" : ["autogroup:admin"],
      "tag:target" : ["autogroup:admin"],
    }
    
    acls : [
      {
        action = "accept",
        src  = ["tag:home"],
        dst  = ["tag:target:80"],
      }
    ],
  })
}

###
resource "tailscale_tailnet_key" "home" {
  reusable      = false
  ephemeral     = false
  preauthorized = true
  expiry        = 3600
  description   = "Home server"
  tags          = ["tag:home"]
  depends_on    = [ tailscale_acl.default_acl ] 
}

resource "local_file" "home_docker_compose" {
  filename = "./home-docker-compose.yml"
  content  = templatefile("./templates/home-docker-compose.tftpl", {
    hostname = "home"
    authkey  = tailscale_tailnet_key.home.key
  })
}

###
resource "tailscale_tailnet_key" "target" {
  reusable      = false
  ephemeral     = false
  preauthorized = true
  expiry        = 3600
  description   = "Target server"
  tags          = ["tag:target"] 
  depends_on    = [ tailscale_acl.default_acl ] 
}

resource "local_file" "target_docker_compose" {
  filename = "./target-docker-compose.yml"
  content  = templatefile("./templates/target-docker-compose.tftpl", {
    hostname = "target"
    dest_ip  = "192.168.178.12"
    authkey  = tailscale_tailnet_key.target.key
  })
}