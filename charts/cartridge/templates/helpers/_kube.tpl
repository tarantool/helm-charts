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
