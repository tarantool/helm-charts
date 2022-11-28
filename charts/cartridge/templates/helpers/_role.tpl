{{- define "role.default.service" }}
 {{- $ := .context }}
type: ClusterIP
clusterIP: ""
loadBalancerIP: ""
loadBalancerSourceRanges: []
externalTrafficPolicy: Cluster
annotations: {}
sessionAffinity: None
sessionAffinityConfig: {}
{{- end -}}
