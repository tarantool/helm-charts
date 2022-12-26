{{- define "cartridge.environment.app" }}
  {{- $ := .context -}}
  {{- $role := .role -}}
  {{- $clusterName := (include "cartridge.fullname" $) -}}
  {{- $memtxMemory := ($role.memtxMemory | default $.Values.tarantool.memtxMemory) -}}
  {{- $memtxMemoryBytes := (include "cartridge.math.memory_quantity_to_bytes" $memtxMemory) | int64 -}}
  {{- $probeUriTimeout := ($role.probeUriTimeout | default $.Values.tarantool.probeUriTimeout) }}
  - name: TARANTOOL_INSTANCE_NAME
    valueFrom:
      fieldRef:
        fieldPath: metadata.name
  - name: TARANTOOL_HTTP_PORT
    value: {{ $.Values.tarantool.ports.http | quote }}
  - name: TARANTOOL_MEMTX_MEMORY
    value: {{ $memtxMemoryBytes | quote }}
  - name: TARANTOOL_PROBE_URI_TIMEOUT
    value: {{ $probeUriTimeout | quote }}
  - name: TARANTOOL_BUCKET_COUNT
    value: {{ $.Values.tarantool.bucketCount | quote }}
  - name: TARANTOOL_WORKDIR
    value: {{ $.Values.tarantool.workDir | quote }}
  - name: TARANTOOL_USER
    value: {{ $.Values.tarantool.auth.user | default "admin" | quote }}
  - name: TARANTOOL_ALIAS
    value: "$(TARANTOOL_INSTANCE_NAME)"
  - name: TARANTOOL_ADVERTISE_HOST
    value: "$(TARANTOOL_INSTANCE_NAME).{{ $clusterName }}.{{ $.Release.Namespace }}.svc.{{ $.Values.clusterDomain }}"
  - name: TARANTOOL_ADVERTISE_URI
    value: "$(TARANTOOL_ADVERTISE_HOST):{{ $.Values.tarantool.ports.tarantool }}"
  - name: TARANTOOL_CONNECTION_STRING
    value: "$(TARANTOOL_ADVERTISE_HOST):{{ $.Values.tarantool.ports.tarantool }}"
  - name: CARTRIDGE_RUN_DIR
    value: {{ $.Values.tarantool.runDir | quote }}
{{- end }}

{{- define "cartridge.environment.extra" }}
  {{- $context := .context }}
  {{- $exist := dict }}
  {{- range $_, $list := .extra }}
    {{- range $list }}
      {{- if not (get $exist .name) }}
- {{ tpl (. | toYaml) $context | indent 2 | trim }}
      {{- end -}}
      {{- $_ := set $exist .name true -}}
    {{- end -}}
  {{- end -}}
{{- end }}
