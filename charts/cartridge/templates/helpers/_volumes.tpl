{{- define "cartridge.volumes.extraVolumeClaimTemplates" }}
  {{- $context := .context }}
  {{- range .volumeClaimTemplates }}
  - {{ tpl (omit . "spec" | toYaml) $context | nindent 4 | trim }}
    {{- if .spec }}
    spec:
      {{- tpl (omit .spec "storageClassName" | toYaml) $context | nindent 4 }}
      {{- if or .spec.storageClassName $context.Values.storageClass }}
      storageClassName: {{ .spec.storageClassName | default $context.Values.storageClass }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
