
cd platform

./chartprep.sh

terraform init

然后修改 flink job 配置

terraform taint module.main.module.funnydb-track-event-processor.helm_release.funnydb_track_event_processor
terraform apply --target=module.main.module.funnydb-track-event-processor

terraform taint module.main.module.funnydb-track-derive-event-processor.helm_release.funnydb_track_derive_event_processor
terraform apply --target=module.main.module.funnydb-track-derive-event-processor

terraform taint module.main.module.funnydb-mutation-event-processor.helm_release.funnydb_mutation_event_processor
terraform apply --target=module.main.module.funnydb-mutation-event-processor


initialSavepointPath: >-
  alluxio://alluxio-master.default.svc.cluster.local:19998/stage-api-server/flink/application/funnydb-mutation-event-process-flow-controller/checkpoints/e1301a3cb27064b4c1cb4e6ca5fc8eae/chk-1112