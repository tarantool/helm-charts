{{- define "cartridge.container.probe" -}}
  {{- $context := .context -}}
  {{- $defaultProbe := .default -}}
  {{- $roleCustomProbe := .customProbe -}}
  {{- $tarantoolCustomProbe := .tarantoolCustomProbe -}}
  {{- $roleProbe := .probe -}}
  {{- $tarantoolProbe := .tarantoolProbe -}}
  {{- $customProbe := $roleCustomProbe | default $tarantoolCustomProbe -}}
  {{- $probe := deepCopy $tarantoolProbe -}}
  {{- if $roleProbe -}}
      {{- $probe = mergeOverwrite $probe $roleProbe }}
  {{- end -}}
  {{- if $customProbe -}}
    {{ tpl ($customProbe | toYaml) $context | indent 0 }}
  {{- else if $probe.enabled -}}
    {{- tpl ((omit $probe "enabled") | toYaml) $context | indent 0 }}
    {{- $defaultProbe | toYaml | nindent 0 }}
  {{- end -}}
{{- end -}}
