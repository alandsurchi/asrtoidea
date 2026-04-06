# Stage 1: Build the Flutter Web application
FROM ghcr.io/cirruslabs/flutter:3.27.1 AS build

# Set working directory
WORKDIR /app

# Copy the pubspec over and get dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Build the web application
# We use the web renderer matching standard flutter configs.
RUN flutter build web --release

# Stage 2: Serve the application using Nginx
FROM nginx:alpine

# Copy the built web application
COPY --from=build /app/build/web /usr/share/nginx/html

# Replace the default Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Railway sets PORT environment variable, expose it
ENV PORT 8080
EXPOSE 8080

# Command to substitute the dynamic port into Nginx and start it
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
