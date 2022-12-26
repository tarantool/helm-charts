{{/*
Kubernetes version
*/}}
{{- define "cartridge.kube.version" -}}
{{- if .Values.kubeVersion }}
{{- .Values.kubeVersion -}}
{{- else }}
{{- .Capabilities.KubeVersion.Version -}}
{{- end -}}
{{- end -}}
