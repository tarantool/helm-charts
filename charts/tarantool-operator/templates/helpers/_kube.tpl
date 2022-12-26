{{/*
Kubernetes version
*/}}
{{- define "tarantool-operator.version" -}}
{{- if .Values.kubeVersion }}
{{- .Values.kubeVersion -}}
{{- else }}
{{- .Capabilities.KubeVersion.Version -}}
{{- end -}}
{{- end -}}

{{/*
Kubernetes RBAC api
*/}}
{{- define "tarantool-operator.rbac.apiVersion" -}}
{{- if semverCompare "<1.17" (include "tarantool-operator.version" .) -}}
{{- `rbac.authorization.k8s.io/v1beta1` -}}
{{- else -}}
{{- `rbac.authorization.k8s.io/v1` -}}
{{- end -}}
{{- end -}}
