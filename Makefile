# build triton-image
# see: https://github.com/triton-inference-server/server/blob/main/docs/build.md

version="22.06" 
proxy_url="127.0.0.1:7890"

checkout:
	git checkout r${version}

build:
	python3 build.py -v --enable-all --proxy ${proxy_url}

build_cpu_onnx: # + python + ensemble
	python3 build.py  \
		--proxy ${proxy_url} \
		--enable-logging --enable-stats --enable-tracing --enable-metrics \
		--endpoint=http --endpoint=grpc \
		--backend=ensemble \
		--backend=python: \
		--backend=onnxruntime

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

# --enable-gpu-metrics --enable-gpu
# --build-type=Debug