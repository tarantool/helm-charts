{{/*
Retrive existing ot generates new tarantool password (cluster coockie)
*/}}
{{- define "cartridge.auth.password.b64" -}}
    {{- if .Values.tarantool.auth.password -}}
        {{- .Values.tarantool.auth.password | b64enc -}}
    {{- else -}}
        {{/*If password not set in values.yaml*/}}
        {{/*lookup for previous secret with password*/}}
        {{- $fullname := (printf "%s-auth" (include "cartridge.fullname" . )) -}}
        {{- $oldPassword := "" -}}
        {{- $oldPasswordSecret := lookup "v1" "Secret" .Release.Namespace $fullname -}}
        {{- if $oldPasswordSecret -}}
            {{- $oldPassword = (index $oldPasswordSecret.data "TARANTOOL_PASSWORD") -}}
        {{- end -}}

        {{- if not $oldPassword  -}}
            {{/*If previous secret is NOT EXIST, then generate random password*/}}
            {{- randAlphaNum 24 | b64enc -}}
        {{- else -}}
            {{- $oldPassword -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
