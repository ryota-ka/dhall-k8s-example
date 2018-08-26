    let OurService = ./OurService.dhall 

in  let service
        : OurService
        = { containerPort = 80
          , environment   = [ { name = "NGINX_PORT", value = "80" } ]
          , image         = "nginx"
          , name          = "nginx"
          , replicas      = 1
          , servicePort   = 8080
          , tag           = "1.15.2"
          }

in  service
