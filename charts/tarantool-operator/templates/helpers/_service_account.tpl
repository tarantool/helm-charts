{{/*
Name of service account
*/}}
{{- define "tarantool-operator.service-account.name" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "tarantool-operator.fullname" .)  }}
{{- else -}}
    {{ default "crds" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
