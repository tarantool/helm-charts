{{/*
Name of service account
*/}}
{{- define "service-account.name" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "chart.fullname" .)  }}
{{- else -}}
    {{ default "crds" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
