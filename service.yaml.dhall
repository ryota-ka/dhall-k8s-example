-- deployment.yaml.dhall

    let Some =
          https://raw.githubusercontent.com/dhall-lang/Prelude/c79c2bc3c46f129cc5b6d594ce298a381bcae92c/Optional/Some 

in  let None =
          https://raw.githubusercontent.com/dhall-lang/Prelude/c79c2bc3c46f129cc5b6d594ce298a381bcae92c/Optional/None 

in  let Service =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/types/io.k8s.api.core.v1.Service.dhall 

in  let ServiceSpec =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/types/io.k8s.api.core.v1.ServiceSpec.dhall 

in  let ServicePort =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/types/io.k8s.api.core.v1.ServicePort.dhall 

in  let ObjectMeta =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/types/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta.dhall 

in  let defaultService =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.api.core.v1.Service.dhall 

in  let defaultMeta =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta.dhall 

in  let defaultServicePort =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.api.core.v1.ServicePort.dhall 

in  let defaultSpec =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.api.core.v1.ServiceSpec.dhall 

in  let OurService = ./OurService.dhall 

in    λ(svc : OurService)
    →     let selector =
                Some
                (List { mapKey : Text, mapValue : Text })
                [ { mapKey = "app", mapValue = svc.name } ]
      
      in  let ports =
                Some
                (List ServicePort)
                [   defaultServicePort { port = svc.servicePort }
                  ⫽ { protocol   = Some Text "TCP"
                    , targetPort =
                        Some
                        < Int : Natural | String : Text >
                        < Int = svc.containerPort | String : Text >
                    }
                ]
      
      in  let metadata
              : ObjectMeta
              = defaultMeta { name = svc.name } ⫽ { labels = selector }
      
      in  let spec
              : ServiceSpec
              =   defaultSpec
                ⫽ { ports    = ports
                  , selector = selector
                  , type     = Some Text "LoadBalancer"
                  }
      
      in  (     defaultService { metadata = metadata }
              ⫽ { spec = Some ServiceSpec spec }
            : Service
          )
