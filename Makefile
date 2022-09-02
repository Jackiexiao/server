# build triton-image
# see: https://github.com/triton-inference-server/server/blob/main/docs/build.md

version="22.06"
proxy_url="192.168.10.22:7890"

checkout:
	git checkout r${version}

build:
	python3 build.py -v --enable-all --proxy ${proxy_url}

# python3 build.py --enable-logging --enable-stats --enable-metrics --endpoint=http --endpoint=grpc --image=base,ubuntu:20.04 --backend=onnxruntime:"main"
build_cpu_onnx: # + python + ensemble
	python3 build.py  \
		--proxy ${proxy_url} \
		--enable-logging --enable-stats --enable-tracing --enable-metrics \
		--endpoint=http --endpoint=grpc \
		--backend=ensemble \
		--backend=python \
		--backend=onnxruntime
	docker tag tritonserver:latest tritonserver:${version}-onnx-py-cpu

build_cpu_sim: # tf2 / torch / onnx + python + ensemble
	python3 build.py  \
		--proxy ${proxy_url} \
		--enable-logging --enable-stats --enable-tracing --enable-metrics \
		--endpoint=http --endpoint=grpc \
		--extra-backend-cmake-arg=tensorflow2:TRITON_TENSORFLOW_INSTALL_EXTRA_DEPS=ON \
		--image=gpu-base,nvcr.io/nvidia/tritonserver:${version}-py3-min \
		--backend=ensemble \
		--backend=python \
		--backend=pytorch \
		--backend=tensorflow2 \
		--backend=onnxruntime 
	docker tag tritonserver:latest tritonserver:${version}-tf2-torch-onnx-py-cpu

build_cpu_sim_debug: # tf2 / torch / onnx + python + ensemble
	python3 build.py  \
		--proxy ${proxy_url} \
		--enable-logging --enable-stats --enable-tracing --enable-metrics \
		--endpoint=http --endpoint=grpc \
		--extra-backend-cmake-arg=tensorflow2:TRITON_TENSORFLOW_INSTALL_EXTRA_DEPS=ON \
		--image=gpu-base,nvcr.io/nvidia/tritonserver:${version}-py3-min \
		--backend=ensemble \
		--backend=python \
		--backend=pytorch \
		--backend=tensorflow2 \
		--backend=onnxruntime \
		--build-type=Debug
	docker tag tritonserver:latest tritonserver:${version}-tf2-torch-onnx-py-cpu-debug


build_sim: # gpu: tf2 / torch / onnx + python + ensemble
	python3 build.py  \
		--proxy ${proxy_url} \
		--enable-logging --enable-stats --enable-tracing --enable-metrics \
		--endpoint=http --endpoint=grpc \
		--enable-gpu-metrics --enable-gpu \
		--backend=ensemble \
		--backend=python \
		--backend=pytorch \
		--backend=tensorflow2 \
		--backend=onnxruntime 
	docker tag tritonserver:latest tritonserver:${version}-tf2-torch-onnx-py