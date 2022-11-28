{{- define "validation.bucketCount" -}}
    {{- if le .Values.tarantool.bucketCount 0.0 -}}
        {{- fail ".Values.bucketCount shoud be greater then 0" -}}
    {{- end -}}
{{- end -}}

{{- define "validation.failover.timeout" -}}
    {{- if le .Values.tarantool.failover.timeout 0.0 -}}
        {{- fail ".Values.failover.timeout shoud be greater then 0" -}}
    {{- end -}}
{{- end -}}

{{- define "validation.failover.etcd2.lockDelay" -}}
    {{- if eq .Values.tarantool.failover.mode "stateful" -}}
        {{- if le .Values.tarantool.failover.etcd2.lockDelay 0.0 -}}
            {{- fail ".Values.failover.etcd2.lockDelay shoud be greater then 0" -}}
        {{- end -}}

        {{- if le .Values.tarantool.failover.etcd2.lockDelay .Values.tarantool.failover.timeout -}}
            {{- fail (printf ".Values.failover.etcd2.lockDelay shoud be greater then .Values.failover.timeout (greater then %f)" .Values.tarantool.failover.timeout) -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "validation.raft" }}
    {{- $ := .context }}
    {{- $role := .role }}
    {{- if eq $.Values.tarantool.failover.mode "raft" -}}
        {{- if not $role.allRw -}}
            {{- if lt ($role.replicas | int) (3 | int) -}}
                {{- fail (printf "RAFT failover cannot be enabled if any non-allRw role has less than 3 replicas. Please increase replicas for role `%s`" $role.name) -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end }}

{{- define "validation.memtxMemory" }}
    {{- $ := .context }}
    {{- $role := .role }}
    {{- $memtxMemory := $role.memtxMemory | default $.Values.tarantool.memtxMemory }}
    {{- if $memtxMemory -}}
        {{- $memtxMemoryBytes := ((include "tarantool.memory_quantity_to_bytes" $memtxMemory) | int64) -}}
        {{- if le $memtxMemoryBytes 0 }}
            {{- fail (printf "%s.memtxMemory must be greater than 0" $role.name) -}}
        {{- end -}}
        {{- $resources := $role.resources | default $.Values.tarantool.resources }}
        {{- if $resources -}}
            {{- if $resources.limits -}}
                {{- if $resources.limits.memory -}}
                    {{- $memoryLimit := ((include "tarantool.memory_quantity_to_bytes" $resources.limits.memory) | int64) -}}
                    {{- if ge $memtxMemoryBytes $memoryLimit -}}
                         {{- fail (printf
                            "tarantool.roles.%s.memtxMemory (current: %s) must be lover than tarantool.roles.%s.resources.limits.memory (current: %s)"
                            $role.name
                            $role.memtxMemory
                            $role.name
                            $resources.limits.memory
                        ) -}}
                    {{- end -}}
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- else -}}
        {{- fail (printf "%s.memtxMemory doesn't set" $role.name) -}}
    {{- end -}}
{{- end }}
