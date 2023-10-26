### Python base & necessary tools ###
FROM python:3.11-slim-bookworm as base
RUN apt-get update -qqy
RUN apt-get install -qqy librocksdb-dev curl jq
COPY ./requirements.txt .
RUN pip install -r requirements.txt 

### Electrum Rust Server ###
FROM base as electrs-build
RUN apt-get install -qqy clang cmake curl
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
WORKDIR /build/electrs
COPY ./electrs-server .
ENV ROCKSDB_INCLUDE_DIR=/usr/include
ENV ROCKSDB_LIB_DIR=/usr/lib
ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo install --locked --path .
RUN cp -uv /root/.cargo/bin/electrs /usr/bin/electrs

### Electrum Wallet ###
FROM base as electrum-install
RUN apt-get install -qqy electrum

### Finalizing ###
FROM electrum-install as result
COPY --from=electrs-build /root/.cargo/bin/electrs /usr/bin/electrs
WORKDIR /
