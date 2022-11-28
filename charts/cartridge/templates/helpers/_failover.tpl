{{/*
Retrive existing ot generates new etcd2 failover prefix
*/}}
{{- define "failover.etcd2.prefix" -}}
    {{- $fullname := (include "chart.fullname" . ) -}}
    {{- $oldPprefix := lookup "tarantool.io/v1beta1" "FailoverConfig" .Release.Namespace $fullname -}}
    {{- if or (not $oldPprefix) (not (($oldPprefix.spec).etcd2Params).prefix) -}}
        {{- printf "%s-%s" $fullname (randAlphaNum 8) -}}
    {{- else }}
        {{- $oldPprefix.spec.etcd2Params.prefix -}}
    {{- end -}}
{{- end -}}
