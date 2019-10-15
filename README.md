# etcd Quorum Guard

*NOTE: This repository is not the source of the etcd quorum guard;
that has been moved to the machine config operator.  This repository
is present for reference only.*

The etcd Quorum Guard ensures that quorum is maintained for etcd for
[OpenShift](https://openshift.io/).

For the etcd cluster to remain usable, we must maintain quorum, which
is a majority of all etcd members.  For example, an etcd cluster with
3 members (i.e. a 3 master deployment) must have at least 2 healthy
etcd member to meet the quorum limit.

There are situations where 2 etcd members could be down at once:

* a master has gone offline and the MachineConfig Controller (MCC)
  tries to rollout a new MachineConfig (MC) by rebooting masters
* the MCC is doing a MachineConfig rollout and doesn't wait for the
  etcd on the previous master to become healthy again before rebooting
  the next master

In short, we need a way to ensure that a drain on a master is not
allowed to proceed if the reboot of the master would cause etcd quorum
loss.

The etcd quorum guard is implemented as a deployment, with one pod per
master node.

The etcd quorum guard checks the health of etcd by querying the health
endpoint of etcd; if etcd reports itself unhealthy or is not present,
the quorum guard reports itself not ready.  A disruption budget is
used to allow no more than one unhealthy/missing quorum guard (and
hence etcd).  If one etcd is already not healthy or missing, this
disruption budget will act as a drain gate, not allowing an attempt to
drain another node.

This drain gate cannot protect against a second node failing due to
e. g. hardware failure; it can only protect against an attempt to
drain the node in preparation for taking it down.

There is no user or administrator action necessary or available for
the etcd Quorum Guard.
