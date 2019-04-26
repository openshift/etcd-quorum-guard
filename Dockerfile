FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY manifests /manifests
LABEL io.k8s.display-name="OpenShift etcd-quorum-guard" \
      io.k8s.description="This is a component of OpenShift and ensures quorum is maintained on etcd."
