{{/*
Name of service account
*/}}
{{- define "cartridge.service-account.name" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "cartridge.fullname" .)  }}
{{- else -}}
    {{ default "crds" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
