# Build stage
FROM node:20-alpine3.19 AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:1.25.5-alpine3.19
# Update all packages and clean up cache
RUN apk update && \
    apk upgrade --no-cache && \
    rm -rf /var/cache/apk/*

COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
