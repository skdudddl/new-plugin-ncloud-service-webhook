FROM python:3.8-slim

ENV PYTHONUNBUFFERED 1
ENV SPACEONE_PORT 50051
ENV SERVER_TYPE grpc
ENV PKG_DIR /tmp/pkg
ENV SRC_DIR /tmp/src
ENV TEST_DIR /tmp/test/api

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y gcc python3-dev  # gcc와 python3-dev를 설치합니다.

COPY pkg/*.txt ${PKG_DIR}/
RUN pip install --upgrade pip && \
    pip install --upgrade -r ${PKG_DIR}/pip_requirements.txt

COPY src ${SRC_DIR}
COPY test ${TEST_DIR}
ARG CACHEBUST=1
WORKDIR ${SRC_DIR}
RUN python3 setup.py install && \
     rm -rf /tmp/*

EXPOSE ${SPACEONE_PORT}

ENTRYPOINT ["spaceone"]
CMD ["run", "plugin-server", "plugin"]
