
cd platform

terraform init

./chartprep.sh

然后修改 flink job 配置

terraform taint module.main.module.funnydb-track-event-processor.helm_release.funnydb_track_event_processor
terraform apply --target=module.main.module.funnydb-track-event-processor

terraform taint module.main.module.funnydb-track-derive-event-processor.helm_release.funnydb_track_derive_event_processor
terraform apply --target=module.main.module.funnydb-track-derive-event-processor

terraform taint module.main.module.funnydb-mutation-event-processor.helm_release.funnydb_mutation_event_processor
terraform apply --target=module.main.module.funnydb-mutation-event-processor


terraform apply --target="module.main.module.ingest-v3.helm_release.ingest"
terraform apply --target="module.main.module.ingest-v4.helm_release.ingest-v4"