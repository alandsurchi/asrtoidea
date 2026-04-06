# Stage 1: Build the Flutter Web application
FROM debian:bookworm-slim AS build

# Install dependencies required by Flutter
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone Flutter SDK (stable channel — gets latest stable with Dart ^3.9)
RUN git clone --depth 1 --branch stable https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pre-cache Flutter web artifacts
RUN flutter precache --web
RUN flutter doctor -v

# Set working directory
WORKDIR /app

# Copy pubspec first for dependency caching
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Build the web application
RUN flutter build web --release

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy the built web app
COPY --from=build /app/build/web /usr/share/nginx/html

# Replace the default Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Railway sets the PORT environment variable
ENV PORT=8080
EXPOSE 8080

# Substitute the dynamic port into Nginx config and start
CMD sed -i -e 's/\$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
