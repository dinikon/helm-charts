{{/*
Expand the name of the chart.
*/}}
{{- define "ShortLinks.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Define the ShortLinks.namespace template if set with forceNamespace or .Release.Namespace is set
*/}}
{{- define "ShortLinks.namespace" -}}
  {{- default .Release.Namespace .Values.forceNamespace -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ShortLinks.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ShortLinks.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Ensure there is always a way to track down source of the deployment.
It is unlikely AppVersion will be missing, but we will fallback on the
chart's version in that case.
*/}}
{{- define "ShortLinks.version" -}}
{{- if .Chart.AppVersion }}
{{- .Chart.AppVersion -}}
{{- else -}}
{{- printf "v%s" .Chart.Version -}}
{{- end -}}
{{- end -}}

{{/*
Create labels for prometheus
*/}}
{{- define "ShortLinks.common.matchLabels" -}}
app.kubernetes.io/name: {{ include "ShortLinks.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create unified labels for prometheus components
*/}}
{{- define "ShortLinks.common.metaLabels" -}}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
helm.sh/chart: {{ include "ShortLinks.chart" . }}
app.kubernetes.io/part-of: {{ include "ShortLinks.name" . }}
{{- with .Values.commonMetaLabels}}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "ShortLinks.labels" -}}
{{ include "ShortLinks.matchLabels" . }}
{{ include "ShortLinks.common.metaLabels" . }}
{{- end -}}

{{- define "ShortLinks.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.name }}
{{ include "ShortLinks.common.matchLabels" . }}
{{- end -}}


{{/*
Selector labels
*/}}
{{- define "ShortLinks.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ShortLinks.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ShortLinks.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ShortLinks.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
