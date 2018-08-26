-- deployment.yaml.dhall

    let Some =
          https://raw.githubusercontent.com/dhall-lang/Prelude/c79c2bc3c46f129cc5b6d594ce298a381bcae92c/Optional/Some 

in  let Deployment =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/types/io.k8s.api.apps.v1beta2.Deployment.dhall 

in  let Spec =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/types/io.k8s.api.apps.v1beta2.DeploymentSpec.dhall 

in  let PodSpec =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/types/io.k8s.api.core.v1.PodSpec.dhall 

in  let ContainerPort =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/types/io.k8s.api.core.v1.ContainerPort.dhall 

in  let defaultDeployment =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.api.apps.v1beta2.Deployment.dhall 

in  let defaultMeta =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta.dhall 

in  let defaultSpec =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.api.apps.v1beta2.DeploymentSpec.dhall 

in  let defaultTemplate =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.api.core.v1.PodTemplateSpec.dhall 

in  let defaultPodSpec =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.api.core.v1.PodSpec.dhall 

in  let defaultSelector =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector.dhall 

in  let defaultContainer =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.api.core.v1.Container.dhall 

in  let defaultContainerPort =
          https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/default/io.k8s.api.core.v1.ContainerPort.dhall 

in  let OurService = ./OurService.dhall 

in    λ(svc : OurService)
    →     let selector =
                Some
                (List { mapKey : Text, mapValue : Text })
                [ { mapKey = "app", mapValue = svc.name } ]
      
      in  let spec =
                  defaultSpec
                  { selector = defaultSelector ⫽ { matchLabels = selector }
                  , template =
                        defaultTemplate
                        { metadata =
                              defaultMeta { name = svc.name }
                            ⫽ { labels = selector }
                        }
                      ⫽ { spec =
                            Some
                            PodSpec
                            ( defaultPodSpec
                              { containers =
                                  [   defaultContainer { name = svc.name }
                                    ⫽ { image           =
                                          Some
                                          Text
                                          (svc.image ++ ":" ++ svc.tag ++ "")
                                      , imagePullPolicy =
                                          Some Text "IfNotPresent"
                                      , ports           =
                                          Some
                                          (List ContainerPort)
                                          [ defaultContainerPort
                                            { containerPort = svc.containerPort
                                            }
                                          ]
                                      }
                                  ]
                              }
                            )
                        }
                  }
                ⫽ { replicas             = Some Natural svc.replicas
                  , revisionHistoryLimit = Some Natural 10
                  }
      
      in  (     defaultDeployment { metadata = defaultMeta { name = svc.name } }
              ⫽ { spec = Some Spec spec }
            : Deployment
          )
