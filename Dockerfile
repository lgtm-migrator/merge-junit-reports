FROM alpine:3.16@sha256:65a2763f593ae85fab3b5406dc9e80f744ec5b449f269b699b5efd37a07ad32e as build
WORKDIR /build
RUN apk add --no-cache gcc binutils-gold musl-dev libxml2-dev zlib-static make
COPY Makefile *.c *.h ./
RUN make LDFLAGS="--static -Wl,--as-needed,-O1,--sort-common" CFLAGS="-Os" LIBFLAGS="$(xml2-config --libs)" && strip mjr

FROM scratch
COPY --from=build /build/mjr /mjr
