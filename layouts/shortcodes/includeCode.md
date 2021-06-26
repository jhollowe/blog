{{ $fullFile := printf "%s%s/%s" (.Page.File.Dir) (.Page.File.BaseFileName) (.Get "file") }}
{{if fileExists $fullFile -}}
```{{ .Get "lang" }}
{{ $fullFile | readFile | safeHTML }}
```
{{- else}}
file "{{ .Get "file"}}" not found.
{{warnf "include-code: %s includes file \"%s\" which does not exist." .Page.File.Path $fullFile}}
{{- end}} <!-- markdownlint-disable-file -->