{{/*
Kubernetes version
*/}}
{{- define "kube.version" -}}
{{- if .Values.kubeVersion }}
{{- .Values.kubeVersion -}}
{{- else }}
{{- .Capabilities.KubeVersion.Version -}}
{{- end -}}
{{- end -}}

{{/*
Kubernetes RBAC api
*/}}
{{- define "kube.rbac.apiVersion" -}}
{{- if semverCompare "<1.17" (include "kube.version" .) -}}
{{- `rbac.authorization.k8s.io/v1beta1` -}}
{{- else -}}
{{- `rbac.authorization.k8s.io/v1` -}}
{{- end -}}
{{- end -}}
