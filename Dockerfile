FROM rust:slim-bullseye as builder

WORKDIR /app
COPY . .

RUN apt-get update && \
    apt-get install -y \
    pkg-config \
    libssl-dev \
    make \
    gcc \
    libc6-dev \
    && cargo build --release

FROM debian:bullseye-slim

WORKDIR /app
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/videohash_indexer .
ENV RUST_LOG=info
ENV GOOGLE_CLOUD_PROJECT='hot-or-not-feed-intelligence'

EXPOSE 8080

CMD ["./videohash_indexer"]