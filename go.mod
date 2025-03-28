module github.com/docker/compose-cli

go 1.16

require (
	github.com/AlecAivazis/survey/v2 v2.2.3
	github.com/Azure/azure-pipeline-go v0.2.2 // indirect
	github.com/Azure/azure-sdk-for-go v48.2.0+incompatible
	github.com/Azure/azure-storage-file-go v0.8.0
	github.com/Azure/go-autorest/autorest v0.11.12
	github.com/Azure/go-autorest/autorest/adal v0.9.5
	github.com/Azure/go-autorest/autorest/azure/auth v0.5.3
	github.com/Azure/go-autorest/autorest/azure/cli v0.4.2
	github.com/Azure/go-autorest/autorest/date v0.3.0
	github.com/Azure/go-autorest/autorest/to v0.4.0
	github.com/Azure/go-autorest/autorest/validation v0.2.0 // indirect
	github.com/Microsoft/go-winio v0.4.17
	github.com/aws/aws-sdk-go v1.35.33
	github.com/awslabs/goformation/v4 v4.15.6
	github.com/buger/goterm v1.0.0
	github.com/cnabio/cnab-to-oci v0.3.1-beta1
	github.com/compose-spec/compose-go v0.0.0-20210901090333-feb401cda7f7
	github.com/containerd/console v1.0.2
	github.com/containerd/containerd v1.5.4
	github.com/distribution/distribution/v3 v3.0.0-20210316161203-a01c71e2477e
	github.com/docker/cli v20.10.7+incompatible
	github.com/docker/compose/v2 v2.0.0-20210902070652-5b30accf351f
	github.com/docker/docker v20.10.7+incompatible
	github.com/docker/go-connections v0.4.0
	github.com/docker/go-units v0.4.0
	github.com/fatih/color v1.9.0 // indirect
	github.com/gobwas/httphead v0.0.0-20180130184737-2c6c146eadee // indirect
	github.com/gobwas/pool v0.2.0 // indirect
	github.com/gobwas/ws v1.0.4
	github.com/golang/mock v1.5.0
	github.com/golang/protobuf v1.5.2
	github.com/google/go-cmp v0.5.5
	github.com/hashicorp/go-multierror v1.1.0
	github.com/hashicorp/go-uuid v1.0.2
	github.com/iancoleman/strcase v0.1.2
	github.com/joho/godotenv v1.3.0
	github.com/labstack/echo v3.3.10+incompatible
	github.com/labstack/gommon v0.3.0 // indirect
	github.com/mattn/go-ieproxy v0.0.1 // indirect
	github.com/morikuni/aec v1.0.0
	github.com/opencontainers/go-digest v1.0.0
	github.com/opencontainers/image-spec v1.0.1
	github.com/pkg/errors v0.9.1
	github.com/prometheus/tsdb v0.10.0
	github.com/rogpeppe/go-internal v1.5.2 // indirect
	github.com/sanathkr/go-yaml v0.0.0-20170819195128-ed9d249f429b
	github.com/sirupsen/logrus v1.8.1
	github.com/smartystreets/assertions v1.0.0 // indirect
	github.com/spf13/cobra v1.2.1
	github.com/spf13/pflag v1.0.5
	github.com/stretchr/testify v1.7.0
	github.com/valyala/fasttemplate v1.2.1 // indirect
	golang.org/x/oauth2 v0.0.0-20210402161424-2e8d93401602
	golang.org/x/sync v0.0.0-20210220032951-036812b2e83c
	golang.org/x/sys v0.0.0-20210616094352-59db8d763f22
	google.golang.org/grpc v1.38.0
	google.golang.org/protobuf v1.26.0
	gopkg.in/ini.v1 v1.62.0
	gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b
	gotest.tools v2.2.0+incompatible
	gotest.tools/v3 v3.0.3
	helm.sh/helm/v3 v3.6.1-0.20210722154129-5946457ce9ea
	k8s.io/api v0.21.0
	k8s.io/apimachinery v0.21.0
	k8s.io/cli-runtime v0.21.0
	k8s.io/client-go v0.21.0
	rsc.io/letsencrypt v0.0.3 // indirect
	sigs.k8s.io/kustomize/kyaml v0.10.15
)

// (for buildx)
replace github.com/jaguilar/vt100 => github.com/tonistiigi/vt100 v0.0.0-20190402012908-ad4c4a574305
