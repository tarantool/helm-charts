{{- define "cartridge.math.pow" -}}
{{- $number := (.n | float64 ) -}}
{{- $result := (.n | float64 ) -}}
{{- $pow := .p -}}
{{- $until := ((sub $pow 1) | int) -}}
{{- range $_, $__ := until $until -}}
{{- $result = (mulf $result $number) -}}
{{- end -}}
{{ $result }}
{{- end -}}

{{- define "cartridge.math.memory_quantity_to_bytes_impl" -}}
    {{/* The serialization format is:*/}}
    {{/* <quantity>        ::= <signedNumber><suffix>*/}}
    {{/*   (Note that <suffix> may be empty, from the "" case in <decimalSI>.)*/}}
    {{/* <digit>           ::= 0 | 1 | ... | 9*/}}
    {{/* <digits>          ::= <digit> | <digit><digits>*/}}
    {{/* <number>          ::= <digits> | <digits>.<digits> | <digits>. | .<digits>*/}}
    {{/* <sign>            ::= "+" | "-"*/}}
    {{/* <signedNumber>    ::= <number> | <sign><number>*/}}
    {{/* <suffix>          ::= <binarySI> | <decimalExponent> | <decimalSI>*/}}
    {{/* <binarySI>        ::= Ki | Mi | Gi | Ti | Pi | Ei*/}}
    {{/*   (International System of units; See: http://physics.nist.gov/cuu/Units/binary.html)*/}}
    {{/* <decimalSI>       ::= m | "" | k | M | G | T | P | E*/}}
    {{/*   (Note that 1024 = 1Ki but 1000 = 1k; I didn't choose the capitalization.)*/}}
    {{/* <decimalExponent> ::= "e" <signedNumber> | "E" <signedNumber>*/}}
    {{- $value := . -}}
    {{- if regexMatch "^([+-]?[0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$" $value -}}
        {{- if regexMatch "^([+-]?[0-9.]+)[eE]{1}([-+]?[0-9]{1,})$" $value -}}
            {{- /* Exponent suffix */ -}}
            {{- $number := ((regexReplaceAll "^([+-]?[0-9.]+)[eE]{1}([-+]?[0-9]{1,})$" $value "$1") | float64) -}}
            {{- $decimalExponent := ((regexReplaceAll "^([+-]?[0-9.]+)[eE]{1}([-+]?[0-9]{1,})$" $value "$2") | atoi) -}}
            {{- $coef := ((include "cartridge.math.pow" (dict "n" 10.0 "p" $decimalExponent)) | float64 ) -}}
            {{- mulf $number $coef -}}
        {{- else -}}
            {{- if regexMatch "^([+-]?[0-9.]+)(m|Ki|Mi|Gi|Ti|Pi|Ei|k|M|G|T|P|E)$" $value -}}
                {{/* Decemial or binary SI suffix */}}
                {{- $scales := (dict
                  "m"  0.001
                  "Ki" 1024.0
                  "Mi" 1048576.0
                  "Gi" 1073741824.0
                  "Ti" 1099511627776.0
                  "Pi" 1125899906842624.0
                  "Ei" 1152921504606846976.0
                  "k"  1000.0
                  "M"  1000000.0
                  "G"  1000000000.0
                  "T"  1000000000000.0
                  "P"  1000000000000000.0
                  "E"  1000000000000000000.0
                ) -}}
                {{- $number := ((regexReplaceAll "^([+-]?[0-9.]+)(m|Ki|Mi|Gi|Ti|Pi|Ei|k|M|G|T|P|E)$" $value "$1") | float64) -}}
                {{- $scale := (regexReplaceAll "^([+-]?[0-9.]+)(m|Ki|Mi|Gi|Ti|Pi|Ei|k|M|G|T|P|E)$" $value "$2") -}}
                {{- $coef := (get $scales $scale) -}}
                {{- mulf $number $coef -}}
            {{- else -}}
                {{/* No suffix */}}
                {{- $value | float64 -}}
            {{- end -}}
        {{- end -}}
    {{- else -}}
        {{- fail (printf "cannot parse '%s': quantities must match the regular expression '^([+-]?[0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$'" $value) -}}
    {{- end -}}
{{- end -}}

{{- define "cartridge.math.memory_quantity_to_bytes" -}}
{{- ((include "cartridge.math.memory_quantity_to_bytes_impl" .) | trim | float64 | int64 ) -}}
{{- end -}}
